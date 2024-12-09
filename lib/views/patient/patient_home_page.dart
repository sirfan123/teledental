import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../viewmodels/patient_appointment_view_model.dart';
import 'package:teledental/widgets/bottom_nav_bar_widget.dart';
import 'patient_history_page.dart';
import 'patient_message_page.dart';
import '../reminders/reminder_patient_page.dart';

class PatientHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavBarWidget(
      initialIndex: 0, // Highlight the "Home" tab
      pages: [
        PatientHomeContent(), // Home content with calendar
        PatientHistoryPage(), // History content
        PatientMessagePage(), // Messages content
        ReminderPatientPage(), // Reminders content
      ],
      appBarTitle: 'Patient Dashboard',
    );
  }
}

// Home content with calendar logic
class PatientHomeContent extends StatefulWidget {
  @override
  _PatientHomeContentState createState() => _PatientHomeContentState();
}

class _PatientHomeContentState extends State<PatientHomeContent> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final PatientAppointmentViewModel _appointmentViewModel =
      PatientAppointmentViewModel();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _appointmentViewModel.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.all(16.0), // Add padding around the calendar
          child: TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              _showAppointmentDialog(context, selectedDay);
            },
            calendarFormat: CalendarFormat.month,
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              'Welcome to the Patient Home Page!\nSelect a date to book an appointment.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  // Dialog to select an appointment time
  void _showAppointmentDialog(BuildContext context, DateTime selectedDay) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pick an Appointment Time'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('10:00 AM'),
                onTap: () {
                  Navigator.pop(context);
                  _bookAppointment(selectedDay, '10:00 AM');
                },
              ),
              ListTile(
                title: Text('2:00 PM'),
                onTap: () {
                  Navigator.pop(context);
                  _bookAppointment(selectedDay, '2:00 PM');
                },
              ),
              ListTile(
                title: Text('4:30 PM'),
                onTap: () {
                  Navigator.pop(context);
                  _bookAppointment(selectedDay, '4:30 PM');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _bookAppointment(DateTime date, String time) async {
    await _appointmentViewModel.addAppointment(date, time, "John Doe");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Appointment booked for $time on ${date.toLocal()}')),
    );
  }
}

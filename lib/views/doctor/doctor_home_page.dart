import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../viewmodels/doctor_home_view_model.dart';
import '../../models/appointment_model.dart';
import 'package:teledental/widgets/bottom_nav_bar_widget.dart';
import 'doctor_message_page.dart';
import 'doctor_treatment_page.dart';
import '../reminders/reminder_doctor_page.dart';

class DoctorHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavBarWidget(
      initialIndex: 0, // Highlight the "Home" tab
      pages: [
        DoctorHomeContent(), // Home content with calendar and messages
        DoctorTreatmentPage(), // Treatment notes content
        DoctorMessagePage(), // Messages content
        ReminderDoctorPage(), // Reminders content
      ],
      appBarTitle: 'Doctor Dashboard',
    );
  }
}

class DoctorHomeContent extends StatefulWidget {
  @override
  _DoctorHomeContentState createState() => _DoctorHomeContentState();
}

class _DoctorHomeContentState extends State<DoctorHomeContent> {
  final DoctorHomeViewModel _viewModel = DoctorHomeViewModel();

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<AppointmentModel> selectedAppointments = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _viewModel.loadData();
    setState(() {});
  }

  void _showAppointmentsForDate(DateTime selectedDay) {
    final String formattedDate =
        "${selectedDay.year}-${_twoDigit(selectedDay.month)}-${_twoDigit(selectedDay.day)}";

    // Filter appointments for the selected date
    setState(() {
      selectedAppointments = _viewModel.getAppointmentsForDate(formattedDate);
    });

    if (selectedAppointments.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Appointments on $formattedDate'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: selectedAppointments.map((appointment) {
                return ListTile(
                  title: Text(appointment.patient),
                  subtitle: Text('Time: ${appointment.time}\nStatus: ${appointment.status}'),
                );
              }).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    } else {
      // No appointments exist
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('No Appointments'),
            content: Text('No appointments found for $formattedDate.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0), // Add padding around the calendar
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
              _showAppointmentsForDate(selectedDay);
            },
            calendarFormat: CalendarFormat.month,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'High-Severity Messages:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: _viewModel.urgentMessages.isEmpty
              ? Center(
                  child: Text(
                    'No high-severity messages.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: _viewModel.urgentMessages.length,
                  itemBuilder: (context, index) {
                    final message = _viewModel.urgentMessages[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(
                          message.sender,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(message.content),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  String _twoDigit(int number) => number.toString().padLeft(2, '0');
}

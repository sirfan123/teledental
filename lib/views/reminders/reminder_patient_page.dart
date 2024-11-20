import 'package:flutter/material.dart';
import '../../viewmodels/reminder_patient_view_model.dart';
import '../../models/notification_model.dart';

class ReminderPatientPage extends StatefulWidget {
  @override
  _ReminderPatientPageState createState() => _ReminderPatientPageState();
}

class _ReminderPatientPageState extends State<ReminderPatientPage> {
  final ReminderPatientViewModel _viewModel = ReminderPatientViewModel();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _viewModel.loadData();
    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildAppointmentList() {
    if (_viewModel.upcomingAppointments.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'No upcoming appointments.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics:
            NeverScrollableScrollPhysics(), // Prevents scrolling inside the column
        itemCount: _viewModel.upcomingAppointments.length,
        itemBuilder: (context, index) {
          final notification = _viewModel.upcomingAppointments[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(
                notification.title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(notification.message),
              trailing: Text(
                '${notification.dateTime.month}/${notification.dateTime.day} ${notification.dateTime.hour}:${notification.dateTime.minute.toString().padLeft(2, '0')}',
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String hygieneTipMessage =
        _viewModel.hygieneTip?.message ?? 'Keep smiling!';

    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Hygiene Tip
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      color: Colors.lightBlueAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(Icons.lightbulb,
                                color: Colors.white, size: 40),
                            SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                hygieneTipMessage,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Upcoming Appointments
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Upcoming Appointments',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _buildAppointmentList(),
                ],
              ),
            ),
    );
  }
}

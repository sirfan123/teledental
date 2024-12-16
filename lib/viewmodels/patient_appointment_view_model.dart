import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/appointment_model.dart';
import '../services/notification_services.dart';

class PatientAppointmentViewModel {
  List<AppointmentModel> appointments = [];
  late File writableFile;

  Future<void> initializeFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/dummy_data.json';
    writableFile = File(filePath);

    if (!(await writableFile.exists())) {
      print('Copying dummy_data.json to writable directory...');
      final String assetData =
          await rootBundle.loadString('lib/dummy_data.json');
      await writableFile.writeAsString(assetData);
      print('File copied to writable directory: $filePath');
    } else {
      print('Writable file already exists at: $filePath');
    }
  }

  Future<void> loadData() async {
    await initializeFile();
    final String response = await writableFile.readAsString();
    final Map<String, dynamic> data = jsonDecode(response);

    final rawAppointments = data['appointments'] as List<dynamic>? ?? [];
    appointments =
        rawAppointments.map((appt) => AppointmentModel.fromJson(appt)).toList();
  }

  Future<void> addAppointment(
      DateTime date, String time, String patientName) async {
    await loadData();

    final newId = (DateTime.now().millisecondsSinceEpoch ~/ 1000)
        .toString(); // Reduce to seconds
    final formattedDate =
        "${date.year}-${_twoDigit(date.month)}-${_twoDigit(date.day)}";

    final newAppointment = AppointmentModel(
      id: newId,
      date: formattedDate,
      time: time,
      patient: patientName,
      status: "Pending",
    );

    appointments.add(newAppointment);
    await _saveAppointments(newAppointment);

    // Schedule a push notification for the appointment
    final appointmentDateTime = _parseDateTime(newAppointment.date, time);
    await NotificationService.scheduleNotification(
      id: int.parse(newId), // Unique ID for the notification
      title: "Upcoming Appointment",
      body:
          "Your appointment with $patientName is scheduled for $time on $formattedDate.",
      scheduledTime: appointmentDateTime,
    );

    print('Appointment added and notification scheduled!');
  }

  Future<void> _saveAppointments(AppointmentModel newAppointment) async {
    final String response = await writableFile.readAsString();
    final Map<String, dynamic> data = jsonDecode(response);

    data['appointments'] = appointments.map((appt) => appt.toJson()).toList();

    // Add a new notification for the upcoming appointment
    // Let's assume we schedule the reminder 1 day before the appointment
    final appointmentDateTime =
        DateTime.parse("${newAppointment.date}T09:00:00");

    final reminderDateTime = appointmentDateTime.subtract(Duration(days: 1));
    final notificationsList = (data['notifications'] as List<dynamic>?) ?? [];

    notificationsList.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': 'Upcoming Appointment',
      'message':
          'Your appointment with ${newAppointment.patient} is scheduled for ${newAppointment.date} at ${newAppointment.time}.',
      'dateTime': reminderDateTime.toIso8601String(),
    });

    data['notifications'] = notificationsList;

    await writableFile.writeAsString(jsonEncode(data));
    print('Appointments and Notifications updated successfully!');
  }

  String _twoDigit(int number) => number.toString().padLeft(2, '0');

  DateTime _parseDateTime(String date, String time) {
    final isPM = time.contains("PM");
    final timeParts = time.split(" ")[0].split(":");
    int hour =
        int.parse(timeParts[0]) + (isPM && timeParts[0] != "12" ? 12 : 0);
    if (!isPM && timeParts[0] == "12") hour = 0; // Handle 12 AM case
    final int minute = int.parse(timeParts[1]);
    return DateTime.parse(
        "$date ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:00");
  }
}

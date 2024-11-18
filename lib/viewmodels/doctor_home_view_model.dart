import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/appointment_model.dart';
import '../models/message_model.dart';

class DoctorHomeViewModel {
  List<AppointmentModel> appointments = [];
  List<Message> urgentMessages = [];

  Future<void> loadData() async {
    try {
      String data = await rootBundle.loadString('lib/dummy_data.json');
      final jsonData = json.decode(data);

      // Parse appointments
      appointments = (jsonData['appointments'] as List)
          .map((appt) => AppointmentModel.fromJson(appt))
          .toList();

      // Parse urgent messages
      urgentMessages = (jsonData['messages'] as List)
          .where((msg) => msg['isUrgent'] == true)
          .map((msg) => Message.fromJson(msg))
          .toList();

      print('JSON data loaded successfully.');
    } catch (error) {
      print('Error loading data: $error');
    }
  }

  List<AppointmentModel> getAppointmentsForDate(String date) {
    return appointments.where((appt) => appt.date == date).toList();
  }
}

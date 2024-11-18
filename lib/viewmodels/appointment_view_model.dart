import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/appointment_model.dart';

class AppointmentViewModel {
  List<AppointmentModel> appointments = [];

  Future<void> fetchAppointments() async {
    try {
      String data = await rootBundle.loadString('dummy_data.json');
      final jsonData = json.decode(data);
      appointments = (jsonData['appointments'] as List)
          .map((e) => AppointmentModel.fromJson(e))
          .toList();
    } catch (error) {
      print('Error loading appointments: $error');
    }
  }
}

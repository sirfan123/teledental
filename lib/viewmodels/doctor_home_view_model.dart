import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/appointment_model.dart';
import '../models/message_model.dart';

class DoctorHomeViewModel {
  // Lists to store appointments and urgent messages after loading from JSON
  List<AppointmentModel> appointments = [];
  List<Message> urgentMessages = [];

  // Reference to the writable JSON file on the device
  late File writableFile;

  // Ensures we have a writable JSON file in the application's documents directory
  // If it doesn't exist yet, copy the asset dummy_data.json there
  Future<void> initializeFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/dummy_data.json';
    writableFile = File(filePath);

    if (!(await writableFile.exists())) {
      print('Copying dummy_data.json to writable directory...');
      final String assetData =
          await rootBundle.loadString('lib/dummy_data.json');
      // Write it
      await writableFile.writeAsString(assetData);
      print('File copied to writable directory: $filePath');
    } else {
      print('Writable file already exists at: $filePath');
    }
  }

  // Loads appointments and urgent messages from the writable JSON file
  Future<void> loadData() async {
    try {
      // Make sure the file is initialized
      await initializeFile();

      // Read the JSON content from the writable file
      final String response = await writableFile.readAsString();
      final jsonData = json.decode(response);

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

  // Returns a list of appointments for a specific date, filtered from the appointments list
  List<AppointmentModel> getAppointmentsForDate(String date) {
    return appointments.where((appt) => appt.date == date).toList();
  }
}

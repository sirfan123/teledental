import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/appointment_model.dart';

class AppointmentViewModel {
  List<AppointmentModel> appointments = [];
  late File writableFile;

  Future<void> initializeFile() async {
    // Ensures the writable JSON file is set up in the device's documents directory.
    // If the file doesn't exist yet, it copies dummy_data.json from assets into that directory.
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

  Future<void> fetchAppointments() async {
    try {
      await initializeFile();
      final String response = await writableFile.readAsString();
      final Map<String, dynamic> jsonData = json.decode(response);

      appointments = (jsonData['appointments'] as List<dynamic>)
          .map((e) => AppointmentModel.fromJson(e))
          .toList();
    } catch (error) {
      print('Error loading appointments: $error');
    }
  }
}

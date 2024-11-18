import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/treatment_model.dart';
import 'package:flutter/services.dart';

class DoctorTreatmentViewModel {
  List<TreatmentModel> treatmentHistory = [];
  List<Map<String, dynamic>> appointments = [];
  List<Map<String, dynamic>> messages = [];
  late File writableFile;

  Future<void> initializeFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/dummy_data.json';
    writableFile = File(filePath);

    if (!(await writableFile.exists())) {
      print('Copying dummy_data.json to writable directory...');
      final String assetData =
          await rootBundle.loadString('lib/dummy_data.json');
      final Map<String, dynamic> parsedData = jsonDecode(assetData);

      // Ensure all sections exist in the initial copy
      if (parsedData['appointments'] == null) {
        parsedData['appointments'] = [];
      }
      if (parsedData['treatment_history'] == null) {
        parsedData['treatment_history'] = [];
      }
      if (parsedData['messages'] == null) {
        parsedData['messages'] = [];
      }
      if (parsedData['notifications'] == null) {
        parsedData['notifications'] = [];
      }

      await writableFile.writeAsString(jsonEncode(parsedData));
      print('File copied to writable directory: $filePath');
    } else {
      print('Writable file already exists at: $filePath');
    }
  }

  //assets is not writeable in flutter???
  Future<void> loadData() async {
    try {
      await initializeFile();
      final String response = await writableFile.readAsString();
      final Map<String, dynamic> data = jsonDecode(response);

      // Parse treatment history
      treatmentHistory = (data['treatment_history'] as List)
          .map((history) => TreatmentModel.fromJson(history))
          .toList();

      // Parse appointments
      appointments = (data['appointments'] as List)
          .map((appt) => Map<String, dynamic>.from(appt))
          .toList();

      // Parse messages
      messages = (data['messages'] as List)
          .map((msg) => Map<String, dynamic>.from(msg))
          .toList();
    } catch (error) {
      print('Error loading treatment data: $error');
    }
  }

  List<String> get patients =>
      appointments.map((appt) => appt['patient'] as String).toList();

  Future<void> addTreatmentForPatient(
      String patientName, String procedure, String notes) async {
    final appointment = appointments.firstWhere(
      (appt) => appt['patient'] == patientName,
      orElse: () => {},
    );

    if (appointment.isEmpty) {
      print('Error: Patient not found for name $patientName');
      return;
    }

    final patientId = appointment['id'];

    final treatment = TreatmentModel(
      id: patientId,
      date: DateTime.now().toString().split(' ')[0],
      procedure: procedure,
      notes: notes,
    );

    treatmentHistory.add(treatment);

    try {
      final String response = await writableFile.readAsString();
      final Map<String, dynamic> data = jsonDecode(response);

      // Update treatment history in the data
      data['treatment_history'] =
          treatmentHistory.map((treatment) => treatment.toJson()).toList();

      await writableFile.writeAsString(jsonEncode(data));
      print('Treatment added and saved to writable JSON file!');
    } catch (error) {
      print('Error saving treatment data: $error');
    }
  }
}

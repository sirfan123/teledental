import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/treatment_model.dart';

class PatientTreatmentViewModel {
  List<TreatmentModel> treatmentHistory = [];
  late File writableFile;

  // Assuming the current patient's id is "1" or some identifier
  final String currentPatientId = "1"; // In a real app, this would be dynamic

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
    try {
      await initializeFile();
      final String response = await writableFile.readAsString();
      final Map<String, dynamic> data = jsonDecode(response);

      // Parse treatment history from the writable file
      final rawTreatmentHistory =
          data['treatment_history'] as List<dynamic>? ?? [];
      treatmentHistory = rawTreatmentHistory
          .map((history) => TreatmentModel.fromJson(history))
          .toList();

      // Filter treatments for the current patient
      treatmentHistory = treatmentHistory
          .where((treatment) => treatment.id == currentPatientId)
          .toList();
    } catch (error) {
      print('Error loading treatment history: $error');
    }
  }
}

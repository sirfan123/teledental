import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/treatment_model.dart';

class PatientTreatmentViewModel {
  List<TreatmentModel> treatmentHistory = [];

  Future<void> loadData() async {
    try {
      // Load data from dummy_data.json
      final String response =
          await rootBundle.loadString('lib/dummy_data.json');
      final Map<String, dynamic> data = jsonDecode(response);

      // Parse treatment history
      final rawTreatmentHistory =
          data['treatment_history'] as List<dynamic>? ?? [];
      treatmentHistory = rawTreatmentHistory
          .map((history) => TreatmentModel.fromJson(history))
          .toList();

      // Filter treatments for the current patient
      // Assuming the current patient's id is "1"
      final String currentPatientId = "1"; // Replace with actual patient ID
      treatmentHistory = treatmentHistory
          .where((treatment) => treatment.id == currentPatientId)
          .toList();
    } catch (error) {
      print('Error loading treatment history: $error');
    }
  }
}

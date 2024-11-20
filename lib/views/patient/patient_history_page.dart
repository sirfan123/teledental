import 'package:flutter/material.dart';
import '../../viewmodels/patient_treatment_view_model.dart';
import '../../models/treatment_model.dart';

class PatientHistoryPage extends StatefulWidget {
  @override
  _PatientHistoryPageState createState() => _PatientHistoryPageState();
}

class _PatientHistoryPageState extends State<PatientHistoryPage> {
  final PatientTreatmentViewModel _viewModel = PatientTreatmentViewModel();
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

  Widget _buildTreatmentList() {
    if (_viewModel.treatmentHistory.isEmpty) {
      return Center(
        child: Text(
          'No treatment history found.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: _viewModel.treatmentHistory.length,
        itemBuilder: (context, index) {
          final treatment = _viewModel.treatmentHistory[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(
                treatment.procedure,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle:
                  Text('Date: ${treatment.date}\nNotes: ${treatment.notes}'),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _buildTreatmentList(),
    );
  }
}

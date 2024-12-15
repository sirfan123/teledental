import 'package:flutter/material.dart';
import '../../viewmodels/doctor_treatment_view_model.dart';

class DoctorTreatmentPage extends StatefulWidget {
  @override
  _DoctorTreatmentPageState createState() => _DoctorTreatmentPageState();
}

class _DoctorTreatmentPageState extends State<DoctorTreatmentPage> {
  final DoctorTreatmentViewModel _viewModel = DoctorTreatmentViewModel();

  String? selectedPatient;
  TextEditingController _procedureController = TextEditingController();
  TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _viewModel.loadData();
    setState(() {});
  }

  void _addTreatment() {
    if (selectedPatient != null &&
        _procedureController.text.isNotEmpty &&
        _notesController.text.isNotEmpty) {
      _viewModel.addTreatmentForPatient(
        selectedPatient!,
        _procedureController.text,
        _notesController.text,
      );

      // Clear the fields
      _procedureController.clear();
      _notesController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Treatment added for $selectedPatient!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all fields.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: selectedPatient,
            hint: Text('Select a Patient'),
            onChanged: (value) {
              setState(() {
                selectedPatient = value;
              });
            },
            // fixing error on doctor history page
            items: _viewModel.patients
                .toSet() // Remove duplicates by converting to a Set
                .toList() // Convert back to a List
                .map((patient) {
              return DropdownMenuItem(
                value: patient,
                child: Text(patient),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _procedureController,
            decoration: InputDecoration(
              labelText: 'Procedure',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notesController,
            decoration: InputDecoration(
              labelText: 'Notes',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _addTreatment,
            child: Text('Add Treatment'),
          ),
        ],
      ),
    );
  }
}

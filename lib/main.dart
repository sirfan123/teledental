import 'package:flutter/material.dart';
import 'views/portal_page.dart';
import 'views/patient/patient_home_page.dart';
import 'views/doctor/doctor_home_page.dart';

void main() {
  runApp(DentalHealthcareApp());
}

class DentalHealthcareApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dental Healthcare App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => PortalPage(),
        '/patientHome': (context) => PatientHomePage(),
        '/doctorHome': (context) => DoctorHomePage(),
      },
    );
  }
}

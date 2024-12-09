import 'package:flutter/material.dart';

class PortalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Replace 'assets/images/logo.png' with the actual path to your image
            Image.asset(
              'assets/images/dentalLogo.png',
              height: 100, // Adjust as needed
              width: 100, // Adjust as needed
            ),
            SizedBox(height: 20),
            Text(
              'SmileCare',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/patientHome');
              },
              child: Text('Patient'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/doctorHome');
              },
              child: Text('Doctor'),
            ),
          ],
        ),
      ),
    );
  }
}

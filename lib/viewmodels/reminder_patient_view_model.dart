import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/notification_model.dart';

class ReminderPatientViewModel {
  List<NotificationModel> allNotifications = [];
  List<NotificationModel> upcomingAppointments = [];
  NotificationModel? hygieneTip;

  Future<void> loadData() async {
    try {
      // Load data from dummy_data.json
      final String response =
          await rootBundle.loadString('lib/dummy_data.json');
      final Map<String, dynamic> data = jsonDecode(response);

      // Parse notifications
      final rawNotifications = data['notifications'] as List<dynamic>? ?? [];
      allNotifications = rawNotifications
          .map((noti) => NotificationModel.fromJson(noti))
          .toList();

      // Filter notifications for the current patient
      // Assuming current patient's name is "John Doe"
      final String currentPatientName = "John Doe";

      // Filter upcoming appointments
      upcomingAppointments = allNotifications.where((notification) {
        return notification.title == 'Upcoming Appointment' &&
            notification.message.contains(currentPatientName);
      }).toList();

      // Get the hygiene tip
      hygieneTip = allNotifications.firstWhere(
        (notification) => notification.title == 'Hygiene Tip',
        orElse: () => NotificationModel(
          id: '',
          title: 'Hygiene Tip',
          message: 'Keep smiling!',
          dateTime: DateTime.now(),
        ),
      );
    } catch (error) {
      print('Error loading reminders data: $error');
    }
  }
}

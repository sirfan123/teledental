import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/notification_model.dart';

class NotificationsViewModel {
  List<NotificationModel> notifications = [];

  Future<void> loadData() async {
    try {
      // Directly load the dummy_data.json from assets
      final String response = await rootBundle.loadString('lib/dummy_data.json');
      final Map<String, dynamic> data = jsonDecode(response);

      // Safely parse notifications
      final rawNotifications = data['notifications'] as List<dynamic>? ?? [];
      notifications = rawNotifications
          .map((noti) => NotificationModel.fromJson(noti))
          .toList();
    } catch (error) {
      print('Error loading notifications: $error');
    }
  }

  List<NotificationModel> getUpcomingNotifications() {
    final now = DateTime.now();
    return notifications
        .where((notification) => notification.dateTime.isAfter(now))
        .toList();
  }

  Future<void> schedulePushNotification(NotificationModel notification) async {
    // Simulate scheduling a push notification
    print('Push notification scheduled: ${notification.title}');
  }
}

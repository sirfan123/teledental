import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/notification_model.dart';

class NotificationsViewModel {
  List<NotificationModel> notifications = [];
  late File writableFile;

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

      // Safely parse notifications
      final rawNotifications = data['notifications'] as List<dynamic>? ?? [];
      notifications = rawNotifications
          .map((noti) => NotificationModel.fromJson(noti))
          .toList();

      print('Notifications loaded successfully.');
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

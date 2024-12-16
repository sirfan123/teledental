import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/notification_model.dart';

class ReminderPatientViewModel {
  List<NotificationModel> allNotifications = [];
  List<NotificationModel> upcomingAppointments = [];
  NotificationModel? hygieneTip;
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

      // Parse notifications from the writable file
      final rawNotifications = data['notifications'] as List<dynamic>? ?? [];
      allNotifications = rawNotifications
          .map((noti) => NotificationModel.fromJson(noti))
          .toList();
      // Filter notifications for the current patient
      // Assuming current patient's name is "John Doe"
      final String currentPatientName = "John Doe";

      // Filter upcoming appointments from notifications
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

  Future<void> deleteReminder(String reminderId) async {
    // Remove the reminder from the list
    allNotifications
        .removeWhere((notification) => notification.id == reminderId);

    // Update the JSON file
    final String response = await writableFile.readAsString();
    final Map<String, dynamic> data = jsonDecode(response);
    final rawNotifications = data['notifications'] as List<dynamic>? ?? [];

    data['notifications'] =
        rawNotifications.where((notif) => notif['id'] != reminderId).toList();

    await writableFile.writeAsString(jsonEncode(data));
    print('Reminder deleted successfully!');
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/message_model.dart';
import 'package:flutter/services.dart';

class MessagesViewModel {
  List<Message> messages = [];
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

      // Safely parse messages
      final rawMessages = data['messages'] as List<dynamic>? ?? [];
      messages = rawMessages.map((msg) => Message.fromJson(msg)).toList();

      // Sort messages: high-urgency first
      messages.sort((a, b) {
        if (a.isUrgent && !b.isUrgent) {
          return -1; // a comes before b
        } else if (!a.isUrgent && b.isUrgent) {
          return 1; // b comes before a
        } else {
          return 0; // no change in order
        }
      });
    } catch (error) {
      print('Error loading messages: $error');
    }
  }

  Future<void> sendMessageResponse(String messageId, String response) async {
    try {
      final message = messages.firstWhere((msg) => msg.id == messageId);
      message.response = response;

      final updatedData = {
        "messages": messages.map((msg) => msg.toJson()).toList(),
      };

      await writableFile.writeAsString(jsonEncode(updatedData));
      print('Response saved successfully!');
    } catch (error) {
      print('Error saving message response: $error');
    }
  }
}

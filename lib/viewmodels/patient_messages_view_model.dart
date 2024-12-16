import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/message_model.dart';

class PatientMessagesViewModel {
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

      // Parse messages
      final rawMessages = data['messages'] as List<dynamic>? ?? [];
      messages = rawMessages.map((msg) => Message.fromJson(msg)).toList();

      // Filter messages for the current patient
      // Assuming current patient's name is "John Doe"
      final String currentPatientName = "John Doe";
      messages = messages.where((msg) {
        return msg.sender == currentPatientName ||
            msg.recipient == currentPatientName;
      }).toList();
    } catch (error) {
      print('Error loading messages: $error');
    }
  }

  Future<void> sendMessage(String content, bool isUrgent) async {
    // Assuming current patient is the sender
    final String currentPatientName = "John Doe";
    final String doctorName = "Dr. Smith";

    // Create a new message
    final newMessage = Message(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(), // Generate a unique ID
      sender: currentPatientName,
      recipient: doctorName,
      content: content,
      isUrgent: isUrgent,
      response: null,
    );

    // Add to the messages list
    messages.add(newMessage);

    try {
      // Read the existing JSON structure
      final String jsonString = await writableFile.readAsString();
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);

      // Add the new message to the messages list in the JSON data
      final messagesList = jsonData['messages'] as List<dynamic>;
      messagesList.add(newMessage.toJson());

      // Update the JSON data
      jsonData['messages'] = messagesList;

      // Write the updated JSON back to the file
      await writableFile.writeAsString(jsonEncode(jsonData));

      print('Message sent successfully!');
    } catch (error) {
      print('Error sending message: $error');
    }
  }

  Future<void> replyToMessage(String messageId, String responseContent) async {
    try {
      // Find the message by ID
      final messageIndex = messages.indexWhere((msg) => msg.id == messageId);

      if (messageIndex != -1) {
        // Update the response in memory
        messages[messageIndex].response = responseContent;

        // Read the existing JSON structure
        final String jsonString = await writableFile.readAsString();
        final Map<String, dynamic> jsonData = jsonDecode(jsonString);

        // Find and update the specific message in the JSON data
        final messagesList = jsonData['messages'] as List<dynamic>;
        final jsonMessageIndex =
            messagesList.indexWhere((msg) => msg['id'] == messageId);

        if (jsonMessageIndex != -1) {
          messagesList[jsonMessageIndex]['response'] = responseContent;
        }

        // Update the JSON data
        jsonData['messages'] = messagesList;

        // Write the updated JSON back to the file
        await writableFile.writeAsString(jsonEncode(jsonData));

        print('Response sent successfully!');
      } else {
        print('Message not found');
      }
    } catch (error) {
      print('Error replying to message: $error');
    }
  }

  // delete messages
  Future<void> deleteMessage(String messageId) async {
    // Remove the message from the list
    messages.removeWhere((message) => message.id == messageId);

    // Update the JSON file
    final String response = await writableFile.readAsString();
    final Map<String, dynamic> data = jsonDecode(response);
    final rawMessages = data['messages'] as List<dynamic>? ?? [];

    data['messages'] =
        rawMessages.where((msg) => msg['id'] != messageId).toList();

    await writableFile.writeAsString(jsonEncode(data));
    print('Message deleted successfully!');
  }
}

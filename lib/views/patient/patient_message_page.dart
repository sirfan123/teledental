import 'package:flutter/material.dart';
import '../../viewmodels/patient_messages_view_model.dart';
import '../../models/message_model.dart';

class PatientMessagePage extends StatefulWidget {
  @override
  _PatientMessagePageState createState() => _PatientMessagePageState();
}

class _PatientMessagePageState extends State<PatientMessagePage> {
  final PatientMessagesViewModel _viewModel = PatientMessagesViewModel();
  final TextEditingController _messageController = TextEditingController();
  bool _isUrgent = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _viewModel.loadData();
    setState(() {});
  }

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _viewModel.sendMessage(_messageController.text, _isUrgent);
      _messageController.clear();
      _isUrgent = false;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Message sent successfully!')),
      );
    }
  }

  void _replyToMessage(Message message) {
    final TextEditingController _responseController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Reply to ${message.sender}'),
          content: TextField(
            controller: _responseController,
            decoration: InputDecoration(
              labelText: 'Your Response',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _responseController.dispose();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_responseController.text.isNotEmpty) {
                  await _viewModel.replyToMessage(
                      message.id, _responseController.text);
                  setState(() {});
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Response sent successfully!')),
                  );
                  _responseController.dispose();
                }
              },
              child: Text('Send'),
            ),
          ],
        );
      },
    );
  }

  void _deleteMessage(String messageId) async {
    await _viewModel.deleteMessage(messageId);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Message deleted successfully!')),
    );
  }

  Widget _buildMessageList() {
    if (_viewModel.messages.isEmpty) {
      return Center(
        child: Text(
          'No messages found.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: _viewModel.messages.length,
        itemBuilder: (context, index) {
          final message = _viewModel.messages[index];
          final isFromDoctor = message.sender.startsWith('Dr.');
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(
                isFromDoctor
                    ? 'From ${message.sender}'
                    : 'To ${message.recipient}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(message.content),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (message.isUrgent)
                    Icon(Icons.priority_high, color: Colors.red),
                  InkWell(
                    onTap: () => _deleteMessage(
                        message.id), // Add your delete logic here
                    child: Image.asset(
                      'assets/images/trash_icon.jpg', // Path to your custom image
                      height: 24, // Adjust size as needed
                      width: 24,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              onTap: () {
                if (isFromDoctor) {
                  // Patient can reply to doctor's message
                  _replyToMessage(message);
                } else if (message.response != null) {
                  // Show the response from the doctor
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Response from ${message.recipient}'),
                        content: Text(message.response!),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CheckboxListTile(
                  title: Text('Mark as High Severity'),
                  value: _isUrgent,
                  onChanged: (value) {
                    setState(() {
                      _isUrgent = value ?? false;
                    });
                  },
                ),
                TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    labelText: 'Compose a message',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _sendMessage,
                  child: Text('Send Message'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

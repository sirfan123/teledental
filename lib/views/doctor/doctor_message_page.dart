import 'package:flutter/material.dart';
import '../../viewmodels/message_view_model.dart';
import '../../models/message_model.dart';

class DoctorMessagePage extends StatefulWidget {
  @override
  _DoctorMessagePageState createState() => _DoctorMessagePageState();
}

class _DoctorMessagePageState extends State<DoctorMessagePage> {
  final MessagesViewModel _viewModel = MessagesViewModel();
  final TextEditingController _responseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _viewModel.loadData();
    setState(() {});
  }

  void _showMessageResponseDialog(Message message) {
    _responseController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Respond to ${message.sender}'),
          content: TextField(
            controller: _responseController,
            decoration: InputDecoration(
              labelText: 'Response',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_responseController.text.isNotEmpty) {
                  await _viewModel.sendMessageResponse(
                    message.id,
                    _responseController.text,
                  );
                  setState(() {});
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Response sent successfully!')),
                  );
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
    await _viewModel
        .deleteMessage(messageId); // Ensure delete logic is in the ViewModel
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Message deleted successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _viewModel.messages.isEmpty
          ? Center(
              child: Text(
                'No messages found.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _viewModel.messages.length,
              itemBuilder: (context, index) {
                final message = _viewModel.messages[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      message.sender,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(message.content),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (message.isUrgent)
                          Icon(Icons.priority_high, color: Colors.red),
                        GestureDetector(
                          onTap: () =>
                              _deleteMessage(message.id), // Delete logic
                          child: Image.asset(
                            'assets/images/trash_icon.jpg', // Path to your delete image
                            height: 24,
                            width: 24,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                    onTap: () => _showMessageResponseDialog(message),
                  ),
                );
              },
            ),
    );
  }
}

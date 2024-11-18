class Message {
  final String id;
  final String sender;
  final String recipient;
  final String content;
  final bool isUrgent;
  String? response;

  Message({
    required this.id,
    required this.sender,
    required this.recipient,
    required this.content,
    required this.isUrgent,
    this.response,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      sender: json['sender'],
      recipient: json['recipient'],
      content: json['content'],
      isUrgent: json['isUrgent'],
      response: json['response'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender,
      'recipient': recipient,
      'content': content,
      'isUrgent': isUrgent,
      'response': response,
    };
  }
}

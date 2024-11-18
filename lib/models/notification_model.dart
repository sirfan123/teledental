class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime dateTime;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.dateTime,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}

class AppointmentModel {
  final String id;
  final String date;
  final String time;
  final String patient;
  final String status;

  AppointmentModel({
    required this.id,
    required this.date,
    required this.time,
    required this.patient,
    required this.status,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'],
      date: json['date'],
      time: json['time'],
      patient: json['patient'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'time': time,
      'patient': patient,
      'status': status,
    };
  }
}

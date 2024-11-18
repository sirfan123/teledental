class TreatmentModel {
  final String id;
  final String date;
  final String procedure;
  String notes;

  TreatmentModel({
    required this.id,
    required this.date,
    required this.procedure,
    required this.notes,
  });

  factory TreatmentModel.fromJson(Map<String, dynamic> json) {
    return TreatmentModel(
      id: json['id'],
      date: json['date'],
      procedure: json['procedure'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'procedure': procedure,
        'notes': notes,
      };
}

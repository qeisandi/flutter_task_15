class Schedule {
  final int id;
  final int fieldId;
  final String date;
  final String startTime;
  final String endTime;
  final int isBooked;
  final String createdAt;
  final String updatedAt;

  Schedule({
    required this.id,
    required this.fieldId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.isBooked,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      fieldId: json['field_id'],
      date: json['date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      isBooked: json['is_booked'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

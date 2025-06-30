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
      id: int.tryParse(json['id'].toString()) ?? 0,
      fieldId: int.tryParse(json['field_id'].toString()) ?? 0,
      date: json['date'].toString(),
      startTime: json['start_time'].toString(),
      endTime: json['end_time'].toString(),
      isBooked: int.tryParse(json['is_booked'].toString()) ?? 0,
      createdAt: json['created_at'].toString(),
      updatedAt: json['updated_at'].toString(),
    );
  }
}

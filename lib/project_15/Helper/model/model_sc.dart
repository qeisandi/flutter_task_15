class AddScheduleResponse {
  final String message;
  final ScheduleData? data;

  AddScheduleResponse({required this.message, this.data});

  factory AddScheduleResponse.fromJson(Map<String, dynamic> json) {
    return AddScheduleResponse(
      message: json['message'],
      data: json['data'] != null ? ScheduleData.fromJson(json['data']) : null,
    );
  }
}

class ScheduleData {
  final int id;
  final int fieldId;
  final String date;
  final String startTime;
  final String endTime;
  final String createdAt;
  final String updatedAt;

  ScheduleData({
    required this.id,
    required this.fieldId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ScheduleData.fromJson(Map<String, dynamic> json) {
    return ScheduleData(
      id: json['id'],
      fieldId: json['field_id'],
      date: json['date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

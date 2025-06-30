class BookingResponse {
  final String message;
  final BookingData data;

  BookingResponse({required this.message, required this.data});

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      message: json['message'],
      data: BookingData.fromJson(json['data']),
    );
  }
}

class BookingData {
  final int id;
  final int userId;
  final int scheduleId;
  final DateTime createdAt;
  final DateTime updatedAt;

  BookingData({
    required this.id,
    required this.userId,
    required this.scheduleId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      id: json['id'],
      userId: json['user_id'],
      scheduleId: json['schedule_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

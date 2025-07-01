class Booking {
  final int id;
  final int scheduleId;
  final String createdAt;
  final Schedule schedule;

  Booking({
    required this.id,
    required this.scheduleId,
    required this.createdAt,
    required this.schedule,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: int.parse(json['id'].toString()),
      scheduleId: int.parse(json['schedule_id'].toString()),
      createdAt: json['created_at'].toString(),
      schedule: Schedule.fromJson(json['schedule']),
    );
  }
}

class Schedule {
  final int id;
  final String date;
  final String startTime;
  final String endTime;
  final int isBooked;
  final Field field;

  Schedule({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.isBooked,
    required this.field,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: int.parse(json['id'].toString()),
      date: json['date'].toString(),
      startTime: json['start_time'].toString(),
      endTime: json['end_time'].toString(),
      isBooked: int.parse(json['is_booked'].toString()),
      field: Field.fromJson(json['field']),
    );
  }
}

class Field {
  final int id;
  final String name;
  final String? imagePath;
  final String pricePerHour;

  Field({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.pricePerHour,
  });

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      id: int.parse(json['id'].toString()),
      name: json['name'].toString(),
      imagePath: json['image_path']?.toString(),
      pricePerHour: json['price_per_hour'].toString(),
    );
  }
}

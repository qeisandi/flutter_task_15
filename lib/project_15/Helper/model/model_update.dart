class UpdateLapangan {
  String? message;
  Update? data;

  UpdateLapangan({this.message, this.data});

  factory UpdateLapangan.fromJson(Map<String, dynamic> json) {
    return UpdateLapangan(
      message: json["message"],
      data: json["data"] != null ? Update.fromJson(json["data"]) : null,
    );
  }

  Map<String, dynamic> toJson() => {"message": message, "data": data?.toJson()};
}

class Update {
  int? id;
  String? name;
  int? pricePerHour;
  String? imageUrl;
  String? imagePath;

  Update({
    this.id,
    this.name,
    this.pricePerHour,
    this.imageUrl,
    this.imagePath,
  });

  factory Update.fromJson(Map<String, dynamic> json) {
    return Update(
      id: json["id"],
      name: json["name"],
      pricePerHour: _parseInt(json["price_per_hour"]),
      imageUrl: json["image_url"]?.toString(),
      imagePath: json["image_path"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price_per_hour": pricePerHour,
    "image_url": imageUrl,
    "image_path": imagePath,
  };

  // Helper agar parsing int selalu aman
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}

class UpdateLapangan {
  String? message;
  Update? data;

  UpdateLapangan({
    this.message,
    this.data,
  });

  factory UpdateLapangan.fromJson(Map<String, dynamic> json) => UpdateLapangan(
        message: json["message"],
        data: json["data"] == null ? null : Update.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data?.toJson(),
      };
}

class Update {
  int? id;
  String? name;
  int? pricePerHour;
  dynamic imageUrl;
  dynamic imagePath;

  Update({
    this.id,
    this.name,
    this.pricePerHour,
    this.imageUrl,
    this.imagePath,
  });

  factory Update.fromJson(Map<String, dynamic> json) => Update(
        id: json["id"],
        name: json["name"],
        pricePerHour: json["price_per_hour"] is int
            ? json["price_per_hour"]
            : int.tryParse(json["price_per_hour"].toString()),
        imageUrl: json["image_url"],
        imagePath: json["image_path"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price_per_hour": pricePerHour,
        "image_url": imageUrl,
        "image_path": imagePath,
      };
}

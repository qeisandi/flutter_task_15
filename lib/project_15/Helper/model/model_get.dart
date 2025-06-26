// To parse this JSON data, do
//
//     final getLapangan = getLapanganFromJson(jsonString);

import 'dart:convert';

GetLapangan getLapanganFromJson(String str) =>
    GetLapangan.fromJson(json.decode(str));

String getLapanganToJson(GetLapangan data) => json.encode(data.toJson());

class GetLapangan {
  String? message;
  List<GetL>? data;

  GetLapangan({this.message, this.data});

  factory GetLapangan.fromJson(Map<String, dynamic> json) => GetLapangan(
    message: json["message"],
    data:
        json["data"] == null
            ? []
            : List<GetL>.from(json["data"]!.map((x) => GetL.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data":
        data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class GetL {
  int? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? imagePath;
  String? pricePerHour;
  String? imageUrl;

  GetL({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.imagePath,
    this.pricePerHour,
    this.imageUrl,
  });

  factory GetL.fromJson(Map<String, dynamic> json) => GetL(
    id: json["id"],
    name: json["name"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    imagePath: json["image_path"],
    pricePerHour: json["price_per_hour"],
    imageUrl: json["image_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "image_path": imagePath,
    "price_per_hour": pricePerHour,
    "image_url": imageUrl,
  };
}

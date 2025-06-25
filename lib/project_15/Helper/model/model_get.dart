// To parse this JSON data, do
//
//     final getLapangan = getLapanganFromJson(jsonString);

import 'dart:convert';

GetLapangan getLapanganFromJson(String str) =>
    GetLapangan.fromJson(json.decode(str));

String getLapanganToJson(GetLapangan data) => json.encode(data.toJson());

class GetLapangan {
  String? message;
  List<Lapangan>? data;

  GetLapangan({this.message, this.data});

  factory GetLapangan.fromJson(Map<String, dynamic> json) => GetLapangan(
    message: json["message"],
    data:
        json["data"] == null
            ? []
            : List<Lapangan>.from(
              json["data"]!.map((x) => Lapangan.fromJson(x)),
            ),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data":
        data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Lapangan {
  int? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  Lapangan({this.id, this.name, this.createdAt, this.updatedAt});

  factory Lapangan.fromJson(Map<String, dynamic> json) => Lapangan(
    id: json["id"],
    name: json["name"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

import 'dart:convert';

AddLapangan addLapanganFromJson(String str) =>
    AddLapangan.fromJson(json.decode(str));

String addLapanganToJson(AddLapangan data) => json.encode(data.toJson());

class AddLapangan {
  String? message;
  Data? data;

  AddLapangan({this.message, this.data});

  factory AddLapangan.fromJson(Map<String, dynamic> json) => AddLapangan(
    message: json["message"],
    data: json["data"] != null ? Data.fromJson(json["data"]) : null,
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data?.toJson()};
}

class Data {
  int? id;
  String? name;
  int? pricePerHour;
  String? imageUrl;

  Data({this.id, this.name, this.pricePerHour, this.imageUrl});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    pricePerHour:
        json["price_per_hour"] is int
            ? json["price_per_hour"]
            : int.tryParse(json["price_per_hour"].toString()),
    imageUrl: json["image_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price_per_hour": pricePerHour,
    "image_url": imageUrl,
  };
}

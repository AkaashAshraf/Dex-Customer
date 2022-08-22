// To parse this JSON data, do
//
//     final package = packageFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Package packageFromJson(String str) => Package.fromJson(json.decode(str));

String packageToJson(Package data) => json.encode(data.toJson());

class Package {
  Package({
    @required this.code,
    @required this.message,
    @required this.data,
  });

  final int code;
  final String message;
  final List<PackageData> data;

  factory Package.fromJson(Map<String, dynamic> json) => Package(
        code: json["code"] == null ? null : json["code"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<PackageData>.from(
                json["data"].map((x) => PackageData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class PackageData {
  PackageData({
    @required this.id,
    @required this.packageTitle,
    @required this.packagePrice,
    @required this.packagePoints,
    @required this.createdAt,
  });

  final int id;
  final String packageTitle;
  final dynamic packagePrice;
  final dynamic packagePoints;
  final DateTime createdAt;

  factory PackageData.fromJson(Map<String, dynamic> json) => PackageData(
        id: json["id"] == null ? null : json["id"],
        packageTitle:
            json["name"] == null ? null : json["name"],
        packagePrice:
            json["price"] == null ? null : json["price"],
        packagePoints:
            json["points_left"] == null ? null : json["points_left"],
        createdAt: json["created"] == null
            ? null
            : DateTime.parse(json["created"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": packageTitle == null ? null : packageTitle,
        "price": packagePrice == null ? null : packagePrice,
        "points_left": packagePoints == null ? null : packagePoints,
        "created": createdAt == null ? null : createdAt.toIso8601String(),
      };
}

// To parse this JSON data, do
//
//     final packageHistory = packageHistoryFromJson(jsonString);

import 'package:meta/meta.dart';

class PackageHistory {
  PackageHistory({
    @required this.status,
    @required this.message,
    @required this.data,
  });

  final int status;
  final String message;
  final String data;

  PackageHistory copyWith({
    int status,
    String message,
    String data,
  }) =>
      PackageHistory(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory PackageHistory.fromJson(Map<String, dynamic> json) => PackageHistory(
        status: json["status"],
        message: json["message"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data,
      };
}

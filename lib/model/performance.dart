// To parse this JSON data, do
//
//     final performance = performanceFromJson(jsonString);

import 'dart:convert';

Performance performanceFromJson(String str) => Performance.fromJson(json.decode(str));

String performanceToJson(Performance data) => json.encode(data.toJson());

class Performance {
  String departmentName;
  String? cpNo;
  int regTime;
  String loginId;
  int workerNo;
  String regDate;
  int departmentNo;
  String position;
  DateTime lastUseDate;
  String workerName;
  String carLicenseNo;
  int photoCount;

  Performance({
    required this.departmentName,
    this.cpNo,
    required this.regTime,
    required this.loginId,
    required this.workerNo,
    required this.regDate,
    required this.departmentNo,
    required this.position,
    required this.lastUseDate,
    required this.workerName,
    required this.carLicenseNo,
    required this.photoCount,
  });

  factory Performance.fromJson(Map<String, dynamic> json) => Performance(
    departmentName: json["departmentName"],
    cpNo: json["cpNo"],
    regTime: json["regTime"],
    loginId: json["loginId"],
    workerNo: json["workerNo"],
    regDate: json["regDate"],
    departmentNo: json["departmentNo"],
    position: json["position"],
    lastUseDate: DateTime.fromMillisecondsSinceEpoch(json["lastUseDate"]),
    workerName: json["workerName"],
    carLicenseNo: json["carLicenseNo"],
    photoCount: json["photoCount"],
  );

  Map<String, dynamic> toJson() => {
    "departmentName": departmentName,
    "cpNo": cpNo,
    "regTime": regTime,
    "loginId": loginId,
    "workerNo": workerNo,
    "regDate": regDate,
    "departmentNo": departmentNo,
    "position": position,
    "lastUseDate": lastUseDate.millisecondsSinceEpoch,
    "workerName": workerName,
    "carLicenseNo": carLicenseNo,
    "photoCount": photoCount,
  };
}

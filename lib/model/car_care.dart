// To parse this JSON data, do
//
//     final carCare = carCareFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';

CarCare carCareFromJson(String str) => CarCare.fromJson(json.decode(str));

String carCareToJson(CarCare data) => json.encode(data.toJson());

class CarCare {
  // String fileName;
  String? ownerCpNo;
  // int workerNo;
  int reqNo;
  int regDate;
  // int fileGroupNo;
  String? carLicenseNo;
  String paymentType;
  int repairShopNo;
  String? ownerName;
  // int fileNo;
  String? fileSavedPath;
  // int departmentNo;
  String yyyyMm;

  CarCare({
    // required this.fileName,
    required this.ownerCpNo,
    // required this.workerNo,
    required this.reqNo,
    required this.regDate,
    // required this.fileGroupNo,
    required this.carLicenseNo,
    required this.paymentType,
    required this.repairShopNo,
    required this.ownerName,
    // required this.fileNo,
    required this.fileSavedPath,
    // required this.departmentNo,
    required this.yyyyMm,
  });

  String get formattedOwnerCpNo {
    if(ownerCpNo==null) {
      return "";
    }
    switch( ownerCpNo!.length) {
      case 11:
        return "${ownerCpNo!.substring(0, 3)}.${ownerCpNo!.substring(3, 7)}${ownerCpNo!.substring(7)}";
      case 12:
        return "${ownerCpNo!.substring(0, 3)}.${ownerCpNo!.substring(3, 6)}${ownerCpNo!.substring(6)}";
      default:
        return ownerCpNo!;
    }
  }

  DateTime get regAt => DateTime.fromMillisecondsSinceEpoch(regDate);

  factory CarCare.fromJson(Map<String, dynamic> json) {
    // debugPrint("yyyyMm:"+(json["yyyyMm"] ?? ""));
    return CarCare(
    // fileName: json["fileName"],
    ownerCpNo: json["ownerCpNo"] ?? "",
    // workerNo: json["workerNo"],
    reqNo: json["reqNo"],
    regDate: json["regDate"] ?? DateTime.now().millisecondsSinceEpoch,
    // fileGroupNo: json["fileGroupNo"],
    carLicenseNo: json["carLicenseNo"] ?? "",
    paymentType: json["paymentType"] ?? "",
    repairShopNo: json["repairShopNo"],
    ownerName: json["ownerName"] ?? "",
    // fileNo: json["fileNo"],
    fileSavedPath: json["fileSavedPath"],
    // departmentNo: json["departmentNo"],
    yyyyMm: json["yyyyMm"] ?? "",
  );
  }

  Map<String, dynamic> toJson() => {
    // "fileName": fileName,
    "ownerCpNo": ownerCpNo,
    // "workerNo": workerNo,
    "reqNo": reqNo,
    "regDate": regDate,
    // "fileGroupNo": fileGroupNo,
    "carLicenseNo": carLicenseNo,
    "paymentType": paymentType,
    "repairShopNo": repairShopNo,
    "ownerName": ownerName,
    // "fileNo": fileNo,
    "fileSavedPath": fileSavedPath,
    // "departmentNo": departmentNo,
    "yyyyMm": yyyyMm,
  };
}

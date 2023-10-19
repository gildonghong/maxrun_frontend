// To parse this JSON data, do
//
//     final carCare = carCareFromJson(jsonString);

import 'dart:convert';

CarCare carCareFromJson(String str) => CarCare.fromJson(json.decode(str));

String carCareToJson(CarCare data) => json.encode(data.toJson());

class CarCare {
  String fileName;
  int repairShopNo;
  String ownerCpNo;
  int workerNo;
  int fileNo;
  String fileSavedPath;
  int reqNo;
  int departmentNo;
  int fileGroupNo;
  String carLicenseNo;
  String paymentType;

  CarCare({
    required this.fileName,
    required this.repairShopNo,
    required this.ownerCpNo,
    required this.workerNo,
    required this.fileNo,
    required this.fileSavedPath,
    required this.reqNo,
    required this.departmentNo,
    required this.fileGroupNo,
    required this.carLicenseNo,
    required this.paymentType,
  });

  factory CarCare.fromJson(Map<String, dynamic> json) => CarCare(
    fileName: json["fileName"],
    repairShopNo: json["repairShopNo"],
    ownerCpNo: json["ownerCpNo"],
    workerNo: json["workerNo"],
    fileNo: json["fileNo"],
    fileSavedPath: json["fileSavedPath"],
    reqNo: json["reqNo"],
    departmentNo: json["departmentNo"],
    fileGroupNo: json["fileGroupNo"],
    carLicenseNo: json["carLicenseNo"],
    paymentType: json["paymentType"],
  );

  Map<String, dynamic> toJson() => {
    "fileName": fileName,
    "repairShopNo": repairShopNo,
    "ownerCpNo": ownerCpNo,
    "workerNo": workerNo,
    "fileNo": fileNo,
    "fileSavedPath": fileSavedPath,
    "reqNo": reqNo,
    "departmentNo": departmentNo,
    "fileGroupNo": fileGroupNo,
    "carLicenseNo": carLicenseNo,
    "paymentType": paymentType,
  };
}

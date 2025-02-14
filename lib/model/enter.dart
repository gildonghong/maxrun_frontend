// To parse this JSON data, do
//
//     final enter = enterFromJson(jsonString);

import 'dart:convert';

import 'package:darty_json/darty_json.dart';
import 'package:flutter/foundation.dart';

import 'memo.dart';

Enter enterFromJson(String str) => Enter.fromJson(json.decode(str));

String enterToJson(Enter data) => json.encode(data.toJson());

class Enter {
  int repairShopNo;
  String clientPath;
  String month;
  String year;
  String repairShopPhotoPath;
  int reqNo;
  String directoryName;
  String carLicenseNo;
  bool maxrunTalkYn;
  bool customerTalkYn;
  String? ownerName;
  String? ownerCpNo;

  List<Memo> memo;

  Enter({
    required this.repairShopNo,
    required this.clientPath,
    required this.month,
    required this.year,
    required this.repairShopPhotoPath,
    required this.reqNo,
    required this.directoryName,
    required this.carLicenseNo,
    required this.memo,
    required this.maxrunTalkYn,
    required this.customerTalkYn,
    this.ownerName,
    this.ownerCpNo
  });

  factory Enter.fromJson(Map<String, dynamic> json) {
    final j = Json.fromMap(json);

    final enter = Enter(
        repairShopNo: json["repairShopNo"],
        clientPath: json["clientPath"],
        month: json["month"],
        year: json["year"],
        repairShopPhotoPath: json["repairShopPhotoPath"],
        reqNo: json["reqNo"],
        directoryName: json["directoryName"],
        carLicenseNo: json["carLicenseNo"],
        maxrunTalkYn: json["maxrunTalkYn"] =="Y",
        customerTalkYn: json["customerTalkYn"] =="Y",
        // memo: (json["memo"] as List<dynamic>? ?? []).map((e)=>Memo.fromJson(e)).toList(),
        memo: j["memo"].listOfValue((p0) => Memo.fromJson(p0),),
      ownerCpNo: json["ownerCpNo"],
      ownerName: json["ownerName"]
    );

    // if( kDebugMode) {
    //   enter.clientPath = "/Users/taeuk/Desktop/cars";
    // }

    return enter;
  }

  Map<String, dynamic> toJson() => {
    "repairShopNo": repairShopNo,
    "clientPath": clientPath,
    "month": month,
    "year": year,
    "repairShopPhotoPath": repairShopPhotoPath,
    "reqNo": reqNo,
    "directoryName": directoryName,
    "carLicenseNo": carLicenseNo,
    "memo": memo.map((e) => e.toJson()),
    "maxrunTalkYn":maxrunTalkYn ? "Y":"N",
    "customerTalkYn":customerTalkYn ? "Y":"N",
    "ownerCpNo":ownerCpNo,
    "ownerName":ownerName,
  };
}

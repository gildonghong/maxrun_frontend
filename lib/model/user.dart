/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation

import 'dart:convert';

class User {
  User({
    required this.departmentName,
    required this.managerYn,
    // required this.uRtoken,
    required this.workerNo,
    // required this.os,
    // required this.iss,
    // required this.ipAddress,
    required this.loginDate,
    // required this.userAgent,
    required this.repairShopNo,
    // required this.osVersion,
    required this.uAtoken,
    required this.departmentNo,
    required this.workerName,
    // required this.position,
    // required this.exp,
    // required this.iat,
    // required this.jti,
    required this.repairShopName,
    // required this.mobileYn,
  });

  String departmentName;
  String managerYn;

  // String uRtoken;
  int workerNo;

  // String os;
  // String iss;
  // String ipAddress;
  int loginDate;

  // String userAgent;
  int repairShopNo;

  // String osVersion;
  String uAtoken;
  int departmentNo;
  String workerName;

  // String position;
  // int exp;
  // int iat;
  // String jti;
  String repairShopName;

  // String mobileYn;

  bool get isSignedIn => workerNo!=-2;
  bool get isManager => managerYn=="Y";


  factory User.fromJson(Map<dynamic, dynamic> json) => User(
        departmentName: json["departmentName"],
        managerYn: json["managerYn"],
        // uRtoken: json["uRtoken"],
        workerNo: json["workerNo"],
        // os: json["os"],
        // iss: json["iss"],
        // ipAddress: json["ipAddress"],
        loginDate: json["loginDate"],
        // userAgent: json["userAgent"],
        repairShopNo: json["repairShopNo"],
        // osVersion: json["osVersion"],
        uAtoken: json["uAtoken"],
        departmentNo: json["departmentNo"],
        workerName: json["workerName"],
        // position: json["position"],
        // exp: json["exp"],
        // iat: json["iat"],
        // jti: json["jti"],
        repairShopName: json["repairShopName"],
        // mobileYn: json["mobileYn"],
      );

  Map<dynamic, dynamic> toJson() => {
        "departmentName": departmentName,
        "managerYn": managerYn,
        // "uRtoken": uRtoken,
        "workerNo": workerNo,
        // "os": os,
        // "iss": iss,
        // "ipAddress": ipAddress,
        "loginDate": loginDate,
        // "userAgent": userAgent,
        "repairShopNo": repairShopNo,
        // "osVersion": osVersion,
        "uAtoken": uAtoken,
        "departmentNo": departmentNo,
        "workerName": workerName,
        // "position": position,
        // "exp": exp,
        // "iat": iat,
        // "jti": jti,
        "repairShopName": repairShopName,
        // "mobileYn": mobileYn,
      };
}

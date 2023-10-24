/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation

import 'dart:convert';

Account accountFromJson(String str) => Account.fromJson(json.decode(str));

String accountToJson(Account data) => json.encode(data.toJson());

class Account {
    Account({
        required this.cpNo,
        required this.managerYn,
        required this.loginId,
        required this.workerNo,
        this.os,
        // required this.regDate,
        this.lastUseDate,
        this.osVersion,
        // required this.regUserId,
        required this.departmentNo,
        required this.departmentName,
        required this.position,
        required this.workerName,
         this.pwd,
        required this.status,
    });

    String? cpNo;
    String managerYn;
    String loginId;
    int workerNo;
    String? os;
    // int regDate;
    DateTime? lastUseDate;
    String? osVersion;
    // int regUserId;
    int departmentNo;
    String departmentName;
    String position;
    String workerName;
    String? pwd;
    String status;

    factory Account.fromJson(Map<dynamic, dynamic> json) => Account(
        cpNo: json["cpNo"],
        managerYn: json["managerYn"],
        loginId: json["loginId"],
        workerNo: json["workerNo"],
        os: json["os"],
        // regDate: json["regDate"],
        lastUseDate: json["lastUseDate"]==null?null:DateTime.fromMillisecondsSinceEpoch(json["lastUseDate"]),
        osVersion: json["osVersion"],
        // regUserId: json["regUserId"],
        departmentNo: json["departmentNo"],
        departmentName: json["departmentName"],
        position: json["position"],
        workerName: json["workerName"],
        pwd:json["pwd"],
        status: json["status"],
    );

    Map<dynamic, dynamic> toJson() => {
        "cpNo": cpNo,
        "managerYn": managerYn,
        "loginId": loginId,
        "workerNo": workerNo,
        "os": os,
        // "regDate": regDate,
        "lastUseDate": lastUseDate?.millisecondsSinceEpoch,
        "osVersion": osVersion,
        // "regUserId": regUserId,
        "departmentNo": departmentNo,
        "departmentName": departmentName,
        "position": position,
        "workerName": workerName,
        "pwd": pwd,
        "status": status,
    };
}

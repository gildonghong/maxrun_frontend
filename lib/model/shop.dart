/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation

import 'dart:convert';

Shop shopFromJson(String str) => Shop.fromJson(json.decode(str));

String shopToJson(Shop data) => json.encode(data.toJson());

class Shop {
    Shop({
        required this.repairShopNo,
        // required this.modiDate,
        required this.maxrunChargerCpNo,
        // required this.regUserId,
        // required this.modiUserId,
        // required this.regDate,
         this.photoSavePath,
         this.repairShopName,
        this.businessNo,
        this.ceoName,
        this.repairShopTelNo,
        // required this.repairShopEmail,
    });

    int repairShopNo;
    // DateTime modiDate;
    String maxrunChargerCpNo;
    // int regUserId;
    // int modiUserId;
    // DateTime regDate;
    String? photoSavePath;
    String? repairShopName;
    String? businessNo;
    String? ceoName;
    String? repairShopTelNo;
    // String repairShopEmail;

    factory Shop.fromJson(Map<dynamic, dynamic> json) => Shop(
        repairShopNo: json["repairShopNo"],
        // modiDate: DateTime.fromMillisecondsSinceEpoch(json["modiDate"]),
        maxrunChargerCpNo: json["maxrunChargerCpNo"],
        // regUserId: json["regUserId"],
        // modiUserId: json["modiUserId"],
        // regDate: DateTime.fromMillisecondsSinceEpoch(json["regDate"]),
        photoSavePath: json["photoSavePath"],
        repairShopName: json["repairShopName"],
        businessNo: json["businessNo"],
        ceoName: json["ceoName"],
        repairShopTelNo: json["repairShopTelNo"],
        // repairShopEmail: json["repairShopEmail"],
    );

    Map<dynamic, dynamic> toJson() => {
        "repairShopNo": repairShopNo,
        // "modiDate": modiDate.millisecondsSinceEpoch,
        "maxrunChargerCpNo": maxrunChargerCpNo,
        // "regUserId": regUserId,
        // "modiUserId": modiUserId,
        // "regDate": regDate.millisecondsSinceEpoch,
        "photoSavePath": photoSavePath,
        "repairShopName": repairShopName,
        "businessNo": businessNo,
        "ceoName": ceoName,
        "repairShopTelNo": repairShopTelNo,
        // "repairShopEmail": repairShopEmail,
    };
}

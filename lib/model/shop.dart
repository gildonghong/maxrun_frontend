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
        required this.photoSavePath,
        required this.repairShopName,
        // required this.repairShopEmail,
    });

    int repairShopNo;
    // DateTime modiDate;
    String maxrunChargerCpNo;
    // int regUserId;
    // int modiUserId;
    // DateTime regDate;
    String photoSavePath;
    String repairShopName;
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
        // "repairShopEmail": repairShopEmail,
    };
}

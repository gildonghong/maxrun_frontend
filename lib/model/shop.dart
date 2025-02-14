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
        required this.useYn,
        // required this.repairShopEmail,
    });

    int repairShopNo;
    // DateTime modiDate;
    String? maxrunChargerCpNo;
    // int regUserId;
    // int modiUserId;
    // DateTime regDate;
    String? photoSavePath;
    String? repairShopName;
    String? businessNo;
    String? ceoName;
    String? repairShopTelNo;
    String useYn;
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
        useYn: json["useYn"]??"Y"
        // repairShopEmail: json["repairShopEmail"],
    );

    factory Shop.none() => Shop(
        repairShopNo: -1,
        // modiDate: DateTime.fromMillisecondsSinceEpoch(json["modiDate"]),
        maxrunChargerCpNo: "",
        // regUserId: json["regUserId"],
        // modiUserId: json["modiUserId"],
        // regDate: DateTime.fromMillisecondsSinceEpoch(json["regDate"]),
        photoSavePath: "",
        repairShopName: "",
        businessNo: "",
        ceoName: "",
        repairShopTelNo: "",
        useYn: "Y",
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
        "useYn": useYn,
        // "repairShopEmail": repairShopEmail,
    };
}

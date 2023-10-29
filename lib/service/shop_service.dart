import 'package:flutter/src/widgets/editable_text.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photoapp/extension/stream_ext.dart';
import 'package:photoapp/model/shop.dart';
import 'package:photoapp/service/user_service.dart';
import 'package:rxdart/rxdart.dart';

import 'api_service.dart';

class ShopService {
  static final _instance = ShopService._();

  factory ShopService() {
    return _instance;
  }

  final list = BehaviorSubject<List<Shop>>.seeded([]);
  final userShop = BehaviorSubject<Shop?>.seeded(null);

  ShopService._() {
    UserService().user.listen((value) {
      if (value == null) {
        userShop.value = null;
      } else {
        get(value.repairShopNo);
      }
    });
  }

  Future<List<Shop>> fetch() async {
    final res = await api.get<List<dynamic>>("/repairshop/list");
    list.value = res.data!.map((e) => Shop.fromJson(e)).toList();
    return list.value;
  }

  Future<Shop> get(int shopNo) async {
    final res = await api.get("/repairshop/$shopNo");
    userShop.value = Shop.fromJson(res.data!);
    return userShop.value!;
  }

  modify(String photoSavedPath, String maxrunChargerCpNo) async {
    await api.post("/repairshop", data: {
      "photoSavedPath": photoSavedPath,
      "maxrunChargerCpNo": maxrunChargerCpNo,
    });

    if (userShop.hasValue) {
      userShop.value = userShop.value
        ?..photoSavePath = photoSavedPath
        ..maxrunChargerCpNo = maxrunChargerCpNo;
    }
  }

  Future hqSave(
      {
int? repairShopNo,
        required String repairShopName,
      required String ceoName,
      required String businessNo,
      required String repairShopTelNo}) async {

    await api.post("/repairshop", data: {
      "repairShopNo": repairShopNo,
      "repairShopName": repairShopName,
      "ceoName": ceoName,
      "businessNo": businessNo,
      "repairShopTelNo": repairShopTelNo,
      // "photoSavedPath":'',
      // "maxrunChargerCpNo":''
    });

    await fetch();
  }
}

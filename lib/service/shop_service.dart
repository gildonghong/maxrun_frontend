import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photoapp/model/shop.dart';
import 'package:photoapp/service/user_service.dart';
import 'package:rxdart/rxdart.dart';

import 'api_service.dart';

class ShopService {
  static final _instance = ShopService._();

  factory ShopService() {
    return _instance;
  }

  ShopService._();

  final shop = BehaviorSubject<Shop?>.seeded(null);

  Future fetch() async {
    final res = await api
        .get("/repairshop/${UserService().user.getValue()?.repairShopNo}");
    shop.value = Shop.fromJson(res.data!);
  }

  modify(String photoSavedPath, String maxrunChargerCpNo) async {
    await api.post("/repairshop", data: {
      "photoSavedPath": photoSavedPath,
      "maxrunChargerCpNo": maxrunChargerCpNo,
    });

    shop.value = shop.value
      ?..photoSavePath = photoSavedPath
      ..maxrunChargerCpNo = maxrunChargerCpNo;
  }
}

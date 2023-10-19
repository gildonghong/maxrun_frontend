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

  final userShop = BehaviorSubject<Shop?>.seeded(null);

  ShopService._(){
    UserService().user.listen((value) {
      if( value == null) {
        userShop.value = null;
      } else {
        fetch(value.repairShopNo);
      }
    });
  }


  Future<Shop> fetch(int shopNo ) async {
    final res = await api
        .get("/repairshop/$shopNo");
    userShop.value = Shop.fromJson(res.data!);
    return userShop.value!;
  }

  modify(String photoSavedPath, String maxrunChargerCpNo) async {
    await api.post("/repairshop", data: {
      "photoSavedPath": photoSavedPath,
      "maxrunChargerCpNo": maxrunChargerCpNo,
    });

    if(userShop.hasValue) {
      userShop.value = userShop.value
        ?..photoSavePath = photoSavedPath
        ..maxrunChargerCpNo = maxrunChargerCpNo;
    }
  }
}

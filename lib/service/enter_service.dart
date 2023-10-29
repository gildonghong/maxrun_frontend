import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photoapp/model/car_care.dart';
import 'package:photoapp/model/enter.dart';
import 'package:photoapp/model/memo.dart';
import 'package:photoapp/model/photo.dart';
import 'package:photoapp/service/user_service.dart';
import 'package:rxdart/rxdart.dart';

import 'api_service.dart';

class EnterService {
  static final _instance = EnterService._();

  factory EnterService() {
    return _instance;
  }

  final list = BehaviorSubject<List<Enter>>.seeded([]);

  EnterService._() {
    // UserService().user.listen((value) {
    //   if (value != null) {
    //     if( list.value.)
    //     fetch();
    //   } else {
    //     list.value = [];
    //   }
    // });
  }

  Future<List<Enter>> fetch({int? repairShopNo, String? carLicenseNo}) async {
    final res = await api.get<List<dynamic>>("/repairshop/enter/list",
        queryParameters: {
          "carLicenseNo": carLicenseNo,
          "repairShopNo": repairShopNo
        });
    list.value = res.data!.map((e) => Enter.fromJson(e)).toList();
    return list.value;
  }

  Future<List<Photo>> getPhotos(int reqNo) async {
    final res = await api
        .get<List<dynamic>>("/repairshop/enter/photo/list",
        options: Options(
          headers: {
            "no_loading": true,
          }
        ),
        queryParameters: {
      "reqNo": reqNo,
    });

    return res.data!.map((e) => Photo.fromJson(e)).toList();
  }

  Future<int> enterIn(
      {int? reqNo,
      String? carLicenseNo,
      String? ownerName,
      String? ownerCpNo,
      String? paymentType,
      List<Memo>? memo}) async {
    final res = await api
        .post<Map<String, dynamic>>("/repairshop/carcare/enterin", data: {
      "reqNo": reqNo,
      "carLicenseNo": carLicenseNo,
      "ownerName": ownerName,
      "ownerCpNo": ownerCpNo,
      "paymentType": paymentType,
      // "memo": memo,
    });

    return res.data!["reqNo"];
  }

  Future<bool> postChemicalRequestMessage(Enter enter) async {
    final res = await api.post<Map<String, dynamic>>(
        "http://www.maxrunphoto.com/repairshop/message",
        data: {
          "target": "maxrun",
          "carLicenseNo": enter.carLicenseNo,
          "reqNo": enter.reqNo,
        });

    final success = res.data?["result"] == "success";

    if( success) {
      enter.maxrunTalkYn = true;
      list.add(list.value);
    }

    return success;
  }

  Future postRepairCompleteMessage(Enter enter) async {
    final res = await api.post<Map<String, dynamic>>(
        "http://www.maxrunphoto.com/repairshop/message",
        data: {
          "target": "customer",
          "carLicenseNo": enter.carLicenseNo,
          "reqNo": enter.reqNo,
          "ownerCpNo": enter.ownerCpNo,
          "ownerName": enter.ownerName,
        });

    final success = res.data?["result"] == "success";

    if( success) {
      enter.customerTalkYn = true;
      list.add(list.value);
    }


    return success;
  }


  Future addMemo(Enter enter, String text) async {
    final res =
        await api.post<Map<String, dynamic>>("/repairshop/carcare/memo", data: {
      "reqNo": enter.reqNo,
      "memo": text,
    });

    debugPrint(jsonEncode(res.data!));

    final memo = Memo.fromJson(res.data!);
    enter.memo.add(memo);

    list.add(list.value);
  }

  Future removeMemo(Enter enter, Memo memo) async {
    final res = await api.post<int>("/repairshop/carcare/memo/delete", data: {
      "memoNo": memo.memoNo,
    });

    enter.memo.remove(memo);
    list.add(list.value);
  }
}

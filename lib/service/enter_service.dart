import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:photoapp/model/car_care.dart';
import 'package:photoapp/model/enter.dart';
import 'package:photoapp/model/memo.dart';
import 'package:photoapp/model/photo.dart';
import 'package:rxdart/rxdart.dart';

import 'api_service.dart';

class EnterService {
  static final _instance = EnterService._();

  factory EnterService() {
    return _instance;
  }

  int? repairShopNo;
  String? carLicenseNo;
  String? fromDate;
  String? toDate;

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

  Future<List<Enter>> fetch() async {
    final res = await api.get<List<dynamic>>("/repairshop/enter/list",
        queryParameters: {
          "carLicenseNo": carLicenseNo,
          "repairShopNo": repairShopNo,
          "fromDate": fromDate,
          "toDate": toDate
        }..removeWhere((key, value) => value == null));
    list.value = res.data!.map((e) => Enter.fromJson(e)).toList();
    return list.value;
  }

  Future<List<Photo>> getPhotos(int reqNo, {int? repairShopNo}) async {
    final res = await api.get<List<dynamic>>("/repairshop/enter/photo/list",
        options: Options(headers: {
          "no_indicator": true,
        }),
        queryParameters: {"reqNo": reqNo, "repairShopNo": repairShopNo}
          ..removeWhere((key, value) => value == null));
    final list = res.data!.map((e) => Photo.fromJson(e)).toList();

    return list;
  }

  Future<CarCare> enterIn(
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
    }..removeWhere((key, value) => value==null));

    return CarCare.fromJson(res.data!);

    /*
    {
    "ownerName": "홍박사",
    "ownerCpNo": "01034543434",
    "paymentType": "보증",
    "carLicenseNo": "55고511221",
    "workerNo": 1,
    "repairShopNo": 1,
    "outReqNo": 66,
    "reqNo": 66
}
    */
  }

  Future delete(int reqNo) async {
    await api.post<Map<String, dynamic>>("/repairshop/carcare/enterin", data: {
      "reqNo": reqNo,
      "delYn": "Y",
    });

    await fetch();
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

    if (success) {
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
        }..removeWhere((key, value) => value==null));

    final success = res.data?["result"] == "success";

    if (success) {
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

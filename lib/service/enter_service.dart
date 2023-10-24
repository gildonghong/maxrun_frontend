import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photoapp/model/car_care.dart';
import 'package:photoapp/model/enter.dart';
import 'package:photoapp/model/memo.dart';
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
    UserService().user.listen((value) {
      if (value != null) {
        fetch();
      } else {
        list.value = [];
      }
    });
  }

  fetch({String? carLicenseNo}) async {
    final res = await api.get<List<dynamic>>("/repairshop/enter/list",
        queryParameters: {"carLicenseNo": carLicenseNo});
    list.value = res.data!.map((e) => Enter.fromJson(e)).toList();
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
      "memo": memo ?? [],
    });

    return res.data!["reqNo"];
  }

  Future addMemo(Enter enter, String text) async {
    enter.memo.add(Memo(regDate: DateTime.now(), text: text));
    await enterIn(reqNo: enter.reqNo, memo:enter.memo);
    list.add(list.value);
  }

  Future removeMemo(Enter enter, Memo memo) async {
    enter.memo.remove(memo);
    await enterIn(reqNo: enter.reqNo, memo:enter.memo);
    list.add(list.value);
  }
}

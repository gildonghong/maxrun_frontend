import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photoapp/model/car_care.dart';
import 'package:photoapp/service/user_service.dart';
import 'package:rxdart/rxdart.dart';

import 'api_service.dart';

class CarCareService {
  static final _instance = CarCareService._();

  factory CarCareService() {
    return _instance;
  }

  final list = BehaviorSubject<List<CarCare>>.seeded([]);
  var loading = false;
  String? carLicenseNo;

  CarCareService._() {
    // UserService().user.listen((value) {
    //   if (value != null) {
    //     fetch();
    //   } else {
    //     list.value = [];
    //   }
    // });
  }

  fetch() async {
    if (loading) {
      return;
    }

    loading = true;

    try {
      final res = await api.get<List<dynamic>>("/repairshop/carcare/list",
          queryParameters: {
            "departmentName": "신규등록",
            "carLicenseNo": carLicenseNo,
            "rowNum": 1,
          }..removeWhere((key, value) => value == null));

      final fetchedList = res.data!.map((e) => CarCare.fromJson(e)).toList()
        // ..sort((a, b) => b.reqNo.compareTo(a.reqNo))
      ;

      list.value = fetchedList;
    } catch (e) {}

    loading = false;
  }

  Future<int> enterIn(
      {int? reqNo,
      required String carLicenseNo,
      String? ownerName,
      required String ownerCpNo,
      String? paymentType}) async {
    final res = await api
        .post<Map<String, dynamic>>("/repairshop/carcare/enterin", data: {
      "reqNo": reqNo,
      "carLicenseNo": carLicenseNo,
      "ownerName": ownerName,
      "ownerCpNo": ownerCpNo,
      "paymentType": paymentType,
    });

    return res.data!["reqNo"];
  }

  Future repair(int reqNo, int departmentNo, List<XFile> photos) async {
    final data = FormData.fromMap({
      "reqNo": reqNo,
      "departmentNo": departmentNo,
    });

    // await MultipartFile.fromFile(scan.localPath, filename: fileName)
    for (var photo in photos) {
      data.files.add(MapEntry(
          "photo",
          MultipartFile.fromBytes((await photo.readAsBytes()).toList(),
              filename: photo.name,
              contentType: photo.mimeType != null
                  ? MediaType.parse(photo.mimeType!)
                  : null)));
      // data.files.add(MapEntry("photo",
      //     MultipartFile.fromStream(file.openRead, await file.length())));
    }

    await api.post<int>("/repairshop/carcare/repair", data: data);

    await fetch();
  }

  Future<void> loadMore() async {
    if (loading || list.value.isEmpty) {
      return;
    }
    if (list.value.last.rowNum == list.value.last.totalCount) {
      return;
    }

    loading = true;

    try {
      final res = await api.get<List<dynamic>>("/repairshop/carcare/list",
          queryParameters: {
            "departmentName": "신규등록",
            "carLicenseNo": carLicenseNo,
            "rowNum": list.value.last.rowNum+1,
          }..removeWhere((key, value) => value == null));

      final fetchedList = res.data!.map((e) => CarCare.fromJson(e)).toList()
        // ..sort((a, b) => b.reqNo.compareTo(a.reqNo))
      ;

      list.value = list.value..addAll(fetchedList);
    } catch (e) {}

    loading = false;

  }
}

import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

import 'api_service.dart';

class CareService {
  static final _instance = CareService._();

  factory CareService() {
    return _instance;
  }

  CareService._();

  Future<int> enterIn(String carLicenseNo, String? ownerName, String ownerCpNo,
      String? paymentType) async {
    final res = await api
        .post<Map<String, dynamic>>("/repairshop/carcare/enterin", data: {
      "carLicenseNo": carLicenseNo,
      "ownerName": ownerName,
      "ownerCpNo": ownerCpNo,
      "paymentType": paymentType,
    });

    return res.data!["reqNo"];
  }

  repair(int reqNo, int departmentNo, List<XFile> photos) async {
    final data = FormData.fromMap({
      "reqNo": reqNo,
      "departmentNo": departmentNo,
    });

    // await MultipartFile.fromFile(scan.localPath, filename: fileName)
    for (var photo in photos) {
      data.files.add(MapEntry("photo",
          MultipartFile.fromBytes((await photo.readAsBytes()).toList(), filename: photo.name, contentType: photo.mimeType != null ? MediaType.parse(photo.mimeType!):null)));
      // data.files.add(MapEntry("photo",
      //     MultipartFile.fromStream(file.openRead, await file.length())));
    }

    final res = await api
        .post<Map<String, dynamic>>("/repairshop/carcare/reqair", data: data);
  }
}

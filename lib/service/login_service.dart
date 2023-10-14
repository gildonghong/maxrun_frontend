import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rxdart/subjects.dart';

import '../model/worker.dart';
import 'api_service.dart';

class LoginService{
  static final LoginService _instance = LoginService._();

  LoginService._(){
    // if( kDebugMode) {
    //   worker.value = Worker(departmentName: "맥스런", managerYn: "Y", uRtoken: "", workerNo: 1, os: "", iss: "", ipAddress: "", loginDate: 1, userAgent: "", repairShopNo: 1, osVersion: "", uAtoken: "", departmentNo: 1, wokerName: "맥스런", position: "관리자", exp: 1, iat: 1, jti: "", repairShopName: "맥스런", mobileYn: "N");
    // }
  }

  factory LoginService() {

    return _instance;
  }


  final worker = BehaviorSubject<Worker?>.seeded(null);

  login(String loginId, String pwd) async {
/*
    final res = await api.get<Map<String,dynamic>>("/login",queryParameters: {
      "loginId":loginId,
      "passwd":pwd,
    });
    worker.value = Worker.fromJson(res.data!);
*/

    EasyLoading.show();

    worker.value =
    Worker(departmentName: "맥스런", managerYn: "Y", uRtoken: "", workerNo: 1, os: "", iss: "", ipAddress: "", loginDate: 1, userAgent: "", repairShopNo: 1, osVersion: "", uAtoken: "", departmentNo: 1, wokerName: "맥스런", position: "관리자", exp: 1, iat: 1, jti: "", repairShopName: "맥스런", mobileYn: "N");

    EasyLoading.showSuccess("로그인 되었습니다.");
  }

  void logout() {
    worker.value = null;
  }
}
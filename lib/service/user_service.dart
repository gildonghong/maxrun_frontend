import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:photoapp/extension/stream_ext.dart';
import 'package:photoapp/model/department.dart';
import 'package:photoapp/preference.dart';
import 'package:photoapp/service/shop_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../model/user.dart';
import 'api_service.dart';
import 'department_service.dart';

class UserService extends PreferenceAdapter<User> {
  static final UserService _instance = UserService._();

  UserService._();

  factory UserService() {
    return _instance;
  }

  // final worker = BehaviorSubject<Worker?>.seeded(null);
  final token = preferences.getString("token", defaultValue: "");
  late final user =
      preferences.getCustomValue("worker", defaultValue: null, adapter: this);

  bool get isManager => user.getValue()?.managerYn == "Y";

  Department? get workerDepartment => DepartmentService().list.value.firstWhereOrNull(
      (element) => element.departmentNo == user.getValue()?.departmentNo);

  login(String loginId, String pwd) async {
    try {
      final res = await api.post<Map<String, dynamic>>("/login", data: {
        "loginId": loginId,
        "passwd": pwd,
      });

      final w = User.fromJson(res.data!);
      await token.setValue(w.uAtoken);
      await ShopService().fetch();
      await DepartmentService().fetch();
      await user.setValue(w);
    } catch (e) {
      // EasyLoading.showError("계정을 찾을 수 없습니다.");
      EasyLoading.showError(e.toString());
    }
  }

  void logout() {
    user.clear();
    token.clear();
  }

  @override
  User? getValue(SharedPreferences preferences, String key) {
    final s = preferences.getString("worker");
    if (s == null) {
      return null;
    }

    return User.fromJson(jsonDecode(s));
  }

  @override
  Future<bool> setValue(
      SharedPreferences preferences, String key, User value) {
    return preferences.setString(key, jsonEncode(value));
  }
}

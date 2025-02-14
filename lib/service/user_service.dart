import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:photoapp/preference.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../model/user.dart';
import 'api_service.dart';

class UserService extends PreferenceAdapter<User> {
  static final UserService _instance = UserService._();

  UserService._();

  factory UserService() {
    return _instance;
  }

  // final worker = BehaviorSubject<Worker?>.seeded(null);
  late final user =
      preferences.getCustomValue("worker", defaultValue: null, adapter: this);

  bool get isManager => user.getValue()?.managerYn == "Y";

  login(String loginId, String pwd) async {
      final res = await api.post<Map<String, dynamic>>("/login", data: {
        "loginId": loginId,
        "passwd": pwd,
      });

      final w = User.fromJson(res.data!);
      await user.setValue(w);
  }

  void logout() {
    user.clear();
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

User get currentUser => UserService().user.getValue()!;
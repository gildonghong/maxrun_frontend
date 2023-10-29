import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:photoapp/env.dart';
import 'package:photoapp/model/user.dart';
import 'package:photoapp/service/user_service.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

var retryCount = 0;
final interceptor = InterceptorsWrapper(
  onRequest: (options, handler) async {
    if( options.headers["no_loading"] != true) {
      EasyLoading.show();
    }

    final token = UserService().user.getValue()?.uAtoken;

    if (token?.isNotEmpty == true) {
      options.headers["Authorization"] = "Bearer $token";
    }

    handler.next(options);
  },
  onResponse: (e, handler) {
    retryCount = 0;
    if( e.requestOptions.headers["no_loading"] != true) {
      EasyLoading.dismiss();
    }
    handler.next(e);
  },
  onError: (error, handler) async {
    var message = "";
    if( error.error is FormatException) {
      final fe = error.error as FormatException;
      message = fe.source;
    } else {
      message = error.response?.data ?? "시스템 오류가 발생했습니다.";
    }
    EasyLoading.showError(message);
    // handler.next(error);
    handler.reject(DioException(requestOptions:error.requestOptions,message: message));
  },
);

class ApiHelper {
  static final option = BaseOptions(
    baseUrl: ENV_BASE_URL,
    connectTimeout: Duration(seconds: 1000 * 20),
    receiveTimeout: Duration(seconds: 1000 * 20),
    contentType: 'application/x-www-form-urlencoded',
    responseType: ResponseType.json,
    receiveDataWhenStatusError: true,
    validateStatus: (status) => status == 200,
  );
}

final Dio api = Dio(ApiHelper.option)
  ..interceptors.addAll([
    // DioLoggingInterceptor(
    //   level: Level.basic,
    //   compact: false,
    // ),
    CookieManager(CookieJar()),
    interceptor,
    LogInterceptor(
        requestBody: true,
        requestHeader: true,
        request: true,
        responseHeader: true,
        responseBody: true)
  ]);

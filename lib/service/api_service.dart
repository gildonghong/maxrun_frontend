import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:photoapp/env.dart';
import 'package:photoapp/service/user_service.dart';

var retryCount = 0;
final interceptor = InterceptorsWrapper(
  onRequest: (options, handler) async {
    if( options.headers["no_indicator"] != true) {
      EasyLoading.show();
    }

    final token = UserService().user.getValue()?.uAtoken;

    if (token?.isNotEmpty == true && options.uri.path != "/login") {
      options.headers["Authorization"] = "Bearer $token";
    }

    handler.next(options);
  },
  onResponse: (e, handler) {
    retryCount = 0;
    if( e.requestOptions.headers["no_indicator"] != true) {
      EasyLoading.dismiss();
    }
    handler.next(e);
  },
  onError: (error, handler) async {
    if( error.response?.statusCode==302 && error.response?.headers.value("location") != null) {
      final redirUrl = error.response!.headers.value("location")!;
      final opts = Options(
          method: error.requestOptions.method,
          headers: error.requestOptions.headers);

      final res = await api.request(redirUrl,
          options: opts,
          data: error.requestOptions.data,
          queryParameters: error.requestOptions.queryParameters);

      handler.resolve(res);
      return;
    }

    var message = "";
    if( error.error is FormatException) {
      final fe = error.error as FormatException;
      message = fe.source;
    } else {
      message = error.response?.data ?? "시스템 오류가 발생했습니다.";
      if( message == "Unauthorized") {
        UserService().logout();

      }
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
    followRedirects: true,
    maxRedirects: 10,
    validateStatus: (status) => status != null && status < 300,
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
        responseBody: true,
    error: true,)
  ]);

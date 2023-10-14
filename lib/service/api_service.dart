import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:photoapp/env.dart';
import 'package:photoapp/model/worker.dart';
import 'package:photoapp/service/login_service.dart';

var retryCount = 0;
final interceptor = InterceptorsWrapper(
  onRequest: (options, handler) async {
    EasyLoading.show();

    // options.headers["Authorization"] = "Bearer $idToken";

    handler.next(options);
  },
  onResponse: (e, handler) {
    retryCount = 0;
    handler.next(e);
    EasyLoading.dismiss();
  },
  onError: (error, handler) async {
    EasyLoading.dismiss();

    Worker? worker = LoginService().worker.valueOrNull;
    RequestOptions? options = error.response?.requestOptions;

    if (error.error == 401 &&
        worker != null &&
        options != null &&
        retryCount < 3) {
      retryCount++;
      // await worker.getIdToken(true);

      final opts = Options(
          method: error.requestOptions.method,
          headers: error.requestOptions.headers);

      handler.resolve(await api.request(options.path,
          options: opts,
          data: options.data,
          queryParameters: options.queryParameters));
    } else {
      EasyLoading.showError("시스템 오류: ${error.response?.data}");
      handler.next(error);
    }
  },
);

class ApiHelper {
  static final option = BaseOptions(
    baseUrl: ENV_BASE_URL,
    connectTimeout: Duration(seconds: 1000 * 20),
    receiveTimeout: Duration(seconds: 1000 * 20),
    contentType: 'application/json',
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
    interceptor,
    LogInterceptor(
        requestBody: true,
        requestHeader: false,
        request: false,
        responseHeader: false)
  ]);

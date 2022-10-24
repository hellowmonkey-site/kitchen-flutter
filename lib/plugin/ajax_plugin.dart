import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitchen_flutter/config/common.dart';
import 'package:kitchen_flutter/helper/application.dart';
import 'package:kitchen_flutter/helper/util.dart';
import 'package:kitchen_flutter/page/login_page.dart';

class AjaxPlugin {
  static void init() {
    Dio dio = Dio(BaseOptions(baseUrl: baseUrl));
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options, handler) {
      final token = Application.prefs.getString('token');
      if (token != null) {
        options.headers['token'] = token;
      }
      options.headers['x-csrf-token'] = generateSecret();
      options.headers['appid'] = appId;
      return handler.next(options);
    }, onResponse: (response, handler) {
      final errno = response.data['errno'];
      final errMsg = response.data['errmsg'].toString();
      if (errno != null && errno != successCode) {
        if (errno == loginError) {
          Get.to(() => const LoginPage(),
              fullscreenDialog: true, transition: Transition.cupertinoDialog);
        }
        return handler.reject(
            DioError(requestOptions: response.requestOptions, error: errMsg));
      }
      return handler.next(response);
    }, onError: (e, handler) {
      Application.toast(e.error, backgroundColor: Colors.red);
      return handler.next(e);
    }));
    Application.ajax = dio;
  }
}

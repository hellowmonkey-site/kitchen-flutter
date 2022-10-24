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
      final status = response.data['status'];
      final message = response.data['message'].toString();
      if (status != null && status != successCode) {
        if (status == loginError) {
          Get.to(() => const LoginPage(),
              fullscreenDialog: true, transition: Transition.downToUp);
        }
        return handler.reject(
            DioError(requestOptions: response.requestOptions, error: message));
      }
      return handler.next(response);
    }, onError: (e, handler) {
      Application.toast(e.message, backgroundColor: Colors.red);
      return handler.next(e);
    }));
    Application.ajax = dio;
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitchen_flutter/config/common.dart';
import 'package:kitchen_flutter/helper/application.dart';
import 'package:kitchen_flutter/helper/util.dart';
import 'package:kitchen_flutter/model/user_model.dart';
// import 'package:kitchen_flutter/page/login_page.dart';
import 'package:kitchen_flutter/provider/user_provider.dart';
import 'package:provider/provider.dart';

class AjaxPlugin {
  static void init() {
    Dio dio = Dio(BaseOptions(baseUrl: baseUrl));
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options, handler) {
      // final token = Application.prefs.getString('token');
      final token =
          Provider.of<UserProvider>(Get.context!, listen: false).token;
      if (token.isNotEmpty) {
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
          Provider.of<UserProvider>(Get.context!, listen: false)
              .setUser(defaultUserModel);
          // Application.navigateTo(() => const LoginPage(),
          // fullscreenDialog: true, transition: Transition.downToUp);
        }
        Application.toast(message, contentColor: Colors.red);
        return handler.reject(
            DioError(requestOptions: response.requestOptions, error: message));
      }
      return handler.next(response);
    }, onError: (e, handler) {
      Application.toast(e.message, contentColor: Colors.red);
      return handler.next(e);
    }));
    Application.ajax = dio;
  }
}

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitchen_flutter/helper/application.dart';
import 'package:kitchen_flutter/model/user_model.dart';

class LoginController extends GetxController {
  // 提交登录
  handleSubmit({required String username, required String password}) {
    final cancel = BotToast.showLoading();
    UserModel.postLogin(username: username, password: password).then((v) {
      Application.toast('登录成功');
      Navigator.of(Get.context!).pop();
    }).whenComplete(() {
      cancel();
    });
  }
}

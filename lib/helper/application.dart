import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:get/get.dart';
import 'package:kitchen_flutter/page/login_page.dart';
import 'package:kitchen_flutter/provider/user_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Application {
  //  请求
  static late Dio ajax;

  //  本地存储
  static late SharedPreferences prefs;

  // 应用信息
  static late PackageInfo packageInfo;

  //  轻提示
  static Function toast(String msg, {Color contentColor = Colors.black87}) {
    return BotToast.showText(
        text: msg,
        contentColor: contentColor,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 20));
  }

  // //  轻提示
  // static Function toast(String msg, {Color contentColor = Colors.black87}) {
  //   return BotToast.showText(
  //       text: msg,
  //       contentColor: contentColor,
  //       contentPadding:
  //           const EdgeInsets.symmetric(vertical: 10, horizontal: 20));
  // }

  //  弹框
  static openDialog(
      {required String title,
      String? content,
      String cancelText = '取消',
      String confirmText = '确认',
      bool autoClose = true,
      required Function onTap}) {
    List<TextButton> actions = [];
    if (cancelText != '') {
      actions.add(TextButton(
        child: Text(cancelText),
        onPressed: () {
          if (autoClose) {
            Navigator.of(Get.context!).pop();
          }
          onTap(false);
        },
      ));
    }
    actions.add(TextButton(
        child: Text(confirmText),
        onPressed: () {
          if (autoClose) {
            Navigator.of(Get.context!).pop();
          }
          onTap(true);
        }));
    showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            elevation: 0,
            title: Text(
              title,
              softWrap: true,
              style: const TextStyle(fontSize: 18),
            ),
            content: content == null
                ? null
                : Text(
                    content,
                    softWrap: true,
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                  ),
            actions: actions.toList(),
          );
        });
  }

  // 链接跳转
  static navigateTo(
    String page, {
    bool auth = false,
  }) {
    final token = Provider.of<UserProvider>(Get.context!, listen: false).token;
    if (auth && token == null) {
      toast('请先登录');
      return Get.to(() => LoginPage(),
          fullscreenDialog: true, transition: Transition.downToUp);
    }
    return Get.toNamed(page);
  }

  // 打开链接
  static void launchUrl(url) async {
    try {
      if (await canLaunchUrl(url)) {
        launchUrl(url);
      } else {
        throw Error();
      }
    } catch (e) {
      toast('无法打开此链接');
    }
  }
}

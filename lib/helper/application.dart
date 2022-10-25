import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
  static void toast(String msg,
      {Color backgroundColor = Colors.black87,
      Color textColor = Colors.white,
      ToastGravity gravity = ToastGravity.BOTTOM}) {
    // Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: backgroundColor,
      textColor: textColor,
      gravity: gravity,
      webBgColor: 'rgba(0, 0, 0, .87)',
      webPosition: 'center',
    );
  }

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
    Function page, {
    transition = Transition.cupertino,
    bool fullscreenDialog = false,
    bool auth = false,
  }) {
    return Get.to(page,
        transition: transition, fullscreenDialog: fullscreenDialog);
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

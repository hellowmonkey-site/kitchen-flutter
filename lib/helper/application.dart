import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Application {
//  请求
  static late Dio ajax;

//  本地存储
  static late SharedPreferences prefs;

//  轻提示
  static void toast(String msg,
      {Color backgroundColor = Colors.black87,
      Color textColor = Colors.white,
      ToastGravity gravity = ToastGravity.BOTTOM}) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: msg,
        backgroundColor: backgroundColor,
        textColor: textColor,
        gravity: gravity);
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

  // 判断数组是否相同
  static bool listEquals(List<int> a1, List<int> a2) {
    if (a1.length != a2.length) return false;
    for (int i = 0; i < a1.length; i++) {
      if (a1[i] != a2[i]) {
        return false;
      }
    }
    return true;
  }
}

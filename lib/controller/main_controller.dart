import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:kitchen_flutter/helper/application.dart';
import 'package:kitchen_flutter/model/common_model.dart';
import 'package:kitchen_flutter/model/user_model.dart';
import 'package:kitchen_flutter/provider/user_provider.dart';
import 'package:provider/provider.dart';

class MainController extends GetxController {
  var pageIndex = Rx<int>(0);

  changePageIndex(int index) {
    pageIndex.value = index;
  }

  @override
  void onReady() {
    // 设置本地用户状态
    if (Provider.of<UserProvider>(Get.context!, listen: false)
        .token
        .isNotEmpty) {
      UserModel.getUserInfo();
    }
    // 检查更新
    CommonModel.getAppInfo().then((data) => {
          if (data.version != Application.packageInfo.version)
            {
              Application.openDialog(
                title: '发现新版本',
                content: data.description,
                confirmText: '立即更新',
              ).then((c) {
                if (c != null) {
                  Application.openUrl(data.downloadUrl);
                }
              })
            }
        });

    Future.delayed(const Duration(seconds: 2)).then((v) {
      FlutterNativeSplash.remove();
    });

    super.onReady();
  }
}

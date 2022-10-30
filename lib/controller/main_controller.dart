import 'package:get/get.dart';
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
    super.onReady();
  }
}

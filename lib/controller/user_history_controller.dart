import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitchen_flutter/model/user_history_model.dart';
import 'package:kitchen_flutter/provider/user_history_provider.dart';
import 'package:provider/provider.dart';

class UserHistoryController extends GetxController {
  @override
  void onReady() {
    if (Provider.of<UserHistoryProvider>(Get.context!, listen: false)
        .historyList
        .isEmpty) {
      BotToast.showLoading(backgroundColor: Colors.transparent);
    }
    UserHistoryModel.getUserHistoryList().whenComplete(() {
      BotToast.closeAllLoading();
    });
    super.onReady();
  }
}

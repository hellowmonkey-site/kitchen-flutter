import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('账号设置'),
        backgroundColor: Theme.of(context).backgroundColor,
        foregroundColor: Get.isDarkMode ? Colors.white : Colors.black,
        shadowColor: Colors.black26,
        elevation: Get.isDarkMode ? 0 : 2,
      ),
      body: const Center(child: Text('开发中...')),
    );
  }
}

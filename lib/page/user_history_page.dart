import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserHistoryPage extends StatelessWidget {
  const UserHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('浏览记录'),
        backgroundColor: Theme.of(context).backgroundColor,
        foregroundColor: Get.isDarkMode ? Colors.white : Colors.black,
        shadowColor: Colors.black26,
        elevation: Get.isDarkMode ? 0 : 2,
      ),
      body: const Center(child: Text('开发中...')),
    );
  }
}

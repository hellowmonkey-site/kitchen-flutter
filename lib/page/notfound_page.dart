import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotfoundPage extends StatelessWidget {
  const NotfoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('页面未找到'),
        ),
        body: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: const Text('页面未找到'),
            ),
            ElevatedButton(
                onPressed: () {
                  Get.toNamed('/');
                },
                child: const Text('返回首页'))
          ],
        )));
  }
}

import 'package:flutter/material.dart';

class UserFavoritePage extends StatelessWidget {
  const UserFavoritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: const Text('我的收藏'),
      ),
      body: const Center(child: Text('开发中...')),
    );
  }
}

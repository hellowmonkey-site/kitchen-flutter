import 'package:flutter/material.dart';

class UserStarPage extends StatelessWidget {
  const UserStarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的关注'),
      ),
      body: const Center(child: Text('开发中...')),
    );
  }
}

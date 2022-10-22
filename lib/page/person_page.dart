import 'package:flutter/material.dart';

class PersonPage extends StatelessWidget {
  const PersonPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('个人主页'),
      ),
      body: const Center(child: Text('开发中...')),
    );
  }
}

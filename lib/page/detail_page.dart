import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
const DetailPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('菜谱详情'),
        elevation: 0,
      ),
      body: const Center(child: Text('开发中...')),
    );
  }
}
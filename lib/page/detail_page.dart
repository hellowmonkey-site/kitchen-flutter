import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitchen_flutter/controller/detail_controller.dart';
import 'package:kitchen_flutter/controller/list_controller.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _appBarHeight = 80;

  final DetailController detailController = Get.put(DetailController());
  final ListController listController = Get.put(ListController());

  double opacity = 0;

  bool onNotification(ScrollNotification notification) {
    double progress = notification.metrics.pixels / _appBarHeight;

    setState(() {
      opacity = notification.metrics.pixels >= _appBarHeight
          ? 1
          : progress >= 0
              ? progress
              : 0;
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            '菜谱详情',
            style: TextStyle(
                color: Theme.of(context)
                    .appBarTheme
                    .foregroundColor
                    ?.withOpacity(opacity)),
          ),
          backgroundColor: Theme.of(context)
              .appBarTheme
              .backgroundColor!
              .withOpacity(opacity),
          elevation: 0,
        ),
        body: NotificationListener<ScrollNotification>(
          onNotification: onNotification,
          child: SingleChildScrollView(
            child: Container(
              color: Colors.red,
              width: MediaQuery.of(context).size.width,
              height: 1000,
              child: const Text('aa'),
            ),
          ),
        ));
  }
}

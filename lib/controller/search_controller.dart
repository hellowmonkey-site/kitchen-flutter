import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  TextEditingController textController = TextEditingController();
  var keywords = Rx<String>('');
  var categorys = Rx<List<String>>([]);

  String get searchTitle => keywords.value.isEmpty
      ? categorys.value.isEmpty
          ? '美食广场'
          : categorys.value.join(',')
      : keywords.value;
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListController extends GetxController {
  // 滚动
  ScrollController scrollController = ScrollController();

  // 数据列表
  var dataList = Rx<List<String>>([]);
  // 分页
  var page = Rx<int>(1);
  var totalPage = Rx<int>(1);
  
  var loading = Rx<bool>(false);

  // list渲染时需要的条数
  get dataItemCount =>
      dataList.value.isEmpty ? 1 : (dataList.value.length / 2).ceil() + 1;

  get hasMore => page.value <= totalPage.value;
}

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitchen_flutter/model/recipe_model.dart';

class ListController extends GetxController {
  // 数据列表
  var dataList = Rx<List<RecipeItemModel>>([]);
  // 分页
  var page = Rx<int>(1);
  var totalPage = Rx<int>(1);

  var loading = Rx<bool>(false);

  var showTopBtn = Rx(false);

  // 滚动
  final ScrollController scrollController = ScrollController();

  // 标题
  String get searchTitle {
    if (Get.parameters['keywords'] == null &&
        Get.parameters['categorys'] == null) {
      return '美食广场';
    }
    return [Get.parameters['keywords'], Get.parameters['categorys']]
        .where((element) => element != '')
        .join(',');
  }

  // list渲染时需要的条数
  get dataItemCount =>
      dataList.value.isEmpty ? 1 : (dataList.value.length / 2).ceil() + 1;

  get hasMore => page.value <= totalPage.value;

  Future fetchData() {
    loading.value = true;
    return RecipeModel.getRecipePageList(
            page: page.value,
            keywords: Get.parameters['keywords'],
            categorys: Get.parameters['categorys'])
        .then((data) {
      page.value = data.page;
      totalPage.value = data.pageCount;
      if (page.value == 1) {
        dataList.value = data.data;
      } else {
        dataList.value = [...dataList.value, ...data.data];
      }
    }).whenComplete(() {
      loading.value = false;
    });
  }

  @override
  void onReady() {
    super.onReady();

    final cancel = BotToast.showLoading(backgroundColor: Colors.transparent);
    fetchData().whenComplete(() {
      cancel();
    });

    // 监听滚动
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        page.value += 1;
        fetchData();
      }
      showTopBtn.value = scrollController.offset > 1000;
      update();
    });
  }
}

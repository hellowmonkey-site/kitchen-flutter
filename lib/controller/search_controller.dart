import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:kitchen_flutter/helper/application.dart';
import 'package:kitchen_flutter/model/category_model.dart';

class SearchController extends GetxController {
  TextEditingController textController = TextEditingController();
  FocusNode focusNode = FocusNode();

  var keywords = Rx<String>('');
  var selectedCategory = Rx<List<String>>([]);

  var categorys = Rx<List<CategoryItemModel>>([]);
  var recommendCategorys = Rx<List<CategoryRecommendItemModel>>([]);

  get canSearch {
    return keywords.value.isNotEmpty || selectedCategory.value.isNotEmpty;
  }

  List<CategoryItemModel> get firstCategorys =>
      categorys.value.where((element) => element.parentId == 0).toList();

  List<CategoryItemModel> get hotCategorys {
    if (categorys.value.isEmpty) {
      return categorys.value;
    }
    final CategoryItemModel hot = categorys.value.firstWhere(
        (element) => element.name.contains('热门'),
        orElse: () => categorys.value.firstWhere(
            (element) => element.parentId == 0,
            orElse: () => categorys.value[0]));
    final list =
        categorys.value.where((element) => element.parentId == hot.id).toList();
    final List<CategoryItemModel> arr = [];
    for (var item in list) {
      arr.addAll(categorys.value.where((v) => v.parentId == item.id).toList());
    }
    return arr;
  }

  // 选择分类
  changeCategory(String name) {
    if (selectedCategory.value.contains(name)) {
      selectedCategory.value =
          selectedCategory.value.where((element) => element != name).toList();
    } else {
      selectedCategory.value = [...selectedCategory.value, name];
    }
    update();
  }

  // 搜索
  handleSearch() {
    focusNode.unfocus();
    Application.navigateTo(
        '/list?keywords=${keywords.value}&categorys=${selectedCategory.value.join(',')}');
  }

  // 清除条件
  handleClear() {
    focusNode.unfocus();
    keywords.value = '';
    selectedCategory.value = [];
    textController.clear();
  }

  @override
  void onReady() async {
    super.onReady();
    final cancel = BotToast.showLoading(backgroundColor: Colors.transparent);
    try {
      recommendCategorys.value = await CategoryModel.getCategoryRecommendList();
      update();
    } finally {
      cancel();
      FlutterNativeSplash.remove();
    }
  }
}

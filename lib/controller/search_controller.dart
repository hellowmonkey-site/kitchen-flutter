import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitchen_flutter/model/category_model.dart';

class SearchController extends GetxController {
  TextEditingController textController = TextEditingController();
  var keywords = Rx<String>('');
  var categorys = Rx<List<CategoryItemModel>>([]);

  // 标题
  String get searchTitle => keywords.value.isEmpty
      ? categorys.value.isEmpty
          ? '美食广场'
          : categorys.value.join(',')
      : keywords.value;

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
    print(arr);
    return arr;
  }

  @override
  void onReady() async {
    super.onReady();
    categorys.value = await CategoryModel.getCategoryList();
    update();
  }
}

import 'package:get/get.dart';
import 'package:kitchen_flutter/model/recipe_model.dart';

class ListController extends GetxController {
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

  @override
  void onReady() {
    super.onReady();
    RecipeModel.getRecipePageList();
  }
}

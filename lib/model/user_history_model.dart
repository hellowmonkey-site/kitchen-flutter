import 'package:get/get.dart';
import 'package:kitchen_flutter/helper/application.dart';
import 'package:kitchen_flutter/model/recipe_model.dart';
import 'package:kitchen_flutter/provider/recipe_provider.dart';
import 'package:kitchen_flutter/provider/user_history_provider.dart';
import 'package:provider/provider.dart';

class UserHistoryItemModel {
  final int id;
  final int userId;
  final int recipeId;
  final String recipeTitle;
  final String recipeCover;
  final String recipeVideo;
  final String createdAt;
  final String updatedAt;

  UserHistoryItemModel(
      {this.id = 0,
      this.userId = 0,
      this.recipeId = 0,
      this.recipeTitle = '',
      this.recipeCover = '',
      this.recipeVideo = '',
      this.updatedAt = '',
      this.createdAt = ''});

  UserHistoryItemModel.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'],
            userId: json['user_id'],
            createdAt: json['created_at'],
            recipeId: json['recipe_id'],
            recipeCover: json['recipe_cover'],
            recipeTitle: json['recipe_title'],
            updatedAt: json['updated_at'],
            recipeVideo: json['recipe_video']);
}

class UserHistoryModel {
  // 获取访问历史
  static Future<List<UserHistoryItemModel>> getUserHistoryList() {
    return Application.ajax.get('user/recipe-history').then((res) {
      final data = (res.data['data'] as List)
          .map((e) => UserHistoryItemModel.fromJson(e))
          .toList();

      // 缓存
      Provider.of<UserHistoryProvider>(Get.context!, listen: false)
          .setHistoryList(data);

      // 缓存菜谱
      Provider.of<RecipeProvider>(Get.context!, listen: false).pushRecipeList(
          data
              .map((item) => RecipeItemModel(
                  categorys: [],
                  materials: [],
                  steps: [],
                  id: item.recipeId,
                  title: item.recipeTitle,
                  cover: item.recipeCover,
                  video: item.recipeVideo))
              .toList());

      return data;
    });
  }

  // 清空浏览记录
  static Future clearUserHistory() {
    return Application.ajax.delete('user/recipe-history/clear').then((value) {
      Application.toast('清空浏览记录成功');
      return getUserHistoryList();
    });
  }

  // 删除浏览记录
  static Future deleteUserHistory(int id) {
    return Application.ajax.delete('user/recipe-history/$id').then((value) {
      Application.toast('删除浏览记录成功');
      return getUserHistoryList();
    });
  }
}

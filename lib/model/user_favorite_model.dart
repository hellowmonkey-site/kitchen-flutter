import 'package:get/get.dart';
import 'package:kitchen_flutter/helper/application.dart';
import 'package:kitchen_flutter/model/recipe_model.dart';
import 'package:kitchen_flutter/provider/recipe_provider.dart';
import 'package:kitchen_flutter/provider/user_favorite_provider.dart';
import 'package:provider/provider.dart';

class UserFavoriteItemModel {
  final int id;
  final int userId;
  final int recipeId;
  final String recipeTitle;
  final String recipeCover;
  final String recipeVideo;
  final String createdAt;

  UserFavoriteItemModel(
      {this.userId = 0,
      this.recipeId = 0,
      this.recipeTitle = '',
      this.recipeCover = '',
      this.recipeVideo = '',
      this.createdAt = '',
      this.id = 0});

  UserFavoriteItemModel.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'],
            createdAt: json['created_at'],
            userId: json['user_id'],
            recipeId: json['recipe_id'],
            recipeCover: json['recipe_cover'],
            recipeTitle: json['recipe_title'],
            recipeVideo: json['recipe_video']);
}

class UserFavoriteModel {
  // 获取收藏列表
  static Future<List<UserFavoriteItemModel>> getUserFavoriteList() {
    return Application.ajax.get('user-favorite').then((res) {
      final data = (res.data['data'] as List)
          .map((e) => UserFavoriteItemModel.fromJson(e))
          .toList();

      // 缓存
      Provider.of<UserFavoriteProvider>(Get.context!, listen: false)
          .setFavoriteList(data);

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

  // 添加收藏
  static Future postUserFavorite(int recipeId) {
    return Application.ajax
        .post('user-favorite', data: {'recipe_id': recipeId}).then((res) {
      getUserFavoriteList();
      return res.data['data'];
    });
  }

  // 取消收藏
  static Future deleteUserFavorite(int recipeId) {
    final id = Provider.of<UserFavoriteProvider>(Get.context!, listen: false)
        .favoriteList
        .firstWhere((element) => element.recipeId == recipeId)
        .id;
    return Application.ajax.delete('user-favorite/$id').then((res) {
      getUserFavoriteList();
      return res.data['data'];
    });
  }
}

import 'package:kitchen_flutter/helper/application.dart';

class UserFavoriteItemModel {
  final int userId;
  final int recipeId;
  final String recipeTitle;
  final String recipeCover;
  final String recipeVideo;
  final String createdAt;

  UserFavoriteItemModel(
      {required this.userId,
      required this.recipeId,
      required this.recipeTitle,
      required this.recipeCover,
      required this.recipeVideo,
      required this.createdAt});

  UserFavoriteItemModel.fromJson(Map<String, dynamic> json)
      : this(
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
    return Application.ajax.get('user-favorite').then((res) =>
        (res.data['data'] as List)
            .map((e) => UserFavoriteItemModel.fromJson(e))
            .toList());
  }

  // 添加收藏
  static Future postUserFavorite(int recipeId) {
    return Application.ajax.post('user-favorite',
        data: {'recipe_id': recipeId}).then((res) => res.data['data']);
  }

  // 取消收藏
  static Future deleteUserFavorite(int recipeId) {
    return Application.ajax.delete('user-favorite',
        data: {'recipe_id': recipeId}).then((res) => res.data['data']);
  }
}

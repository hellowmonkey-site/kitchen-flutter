import 'package:get/get.dart';
import 'package:kitchen_flutter/helper/application.dart';
import 'package:kitchen_flutter/provider/user_history_provider.dart';
import 'package:provider/provider.dart';

class UserHistoryItemModel {
  final int userId;
  final int recipeId;
  final String recipeTitle;
  final String recipeCover;
  final String recipeVideo;
  final String createdAt;

  UserHistoryItemModel(
      {required this.userId,
      required this.recipeId,
      required this.recipeTitle,
      required this.recipeCover,
      required this.recipeVideo,
      required this.createdAt});

  UserHistoryItemModel.fromJson(Map<String, dynamic> json)
      : this(
            createdAt: json['created_at'],
            userId: json['user_id'],
            recipeId: json['recipe_id'],
            recipeCover: json['recipe_cover'],
            recipeTitle: json['recipe_title'],
            recipeVideo: json['recipe_video']);
}

class UserHistoryModel {
  // 获取访问历史
  static Future<List<UserHistoryItemModel>> getUserHistoryList() {
    return Application.ajax.get('user/recipe-history').then((res) {
      final data = (res.data['data'] as List)
          .map((e) => UserHistoryItemModel.fromJson(e))
          .toList();
      Provider.of<UserHistoryProvider>(Get.context!, listen: false)
          .setHistoryList(data);
      return data;
    });
  }
}

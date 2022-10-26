import 'package:kitchen_flutter/helper/application.dart';

class UserStarItemModel {
  final int userId;
  final int starUserId;
  final String starUserName;
  final String starUserCover;
  final String createdAt;

  UserStarItemModel(
      {required this.userId,
      required this.starUserId,
      required this.starUserName,
      required this.starUserCover,
      required this.createdAt});

  UserStarItemModel.fromJson(Map<String, dynamic> json)
      : this(
          createdAt: json['created_at'],
          userId: json['user_id'],
          starUserId: json['star_user_id'],
          starUserName: json['star_user_name'],
          starUserCover: json['star_user_cover'],
        );
}

class UserStarModel {
  // 获取关注列表
  static Future<List<UserStarItemModel>> getUserStarList() {
    return Application.ajax.get('user-star').then((res) =>
        (res.data['data'] as List)
            .map((e) => UserStarItemModel.fromJson(e))
            .toList());
  }

  // 添加关注
  static Future postUserStar(int userId) {
    return Application.ajax.post('user-star',
        data: {'user_id': userId}).then((res) => res.data['data']);
  }

  // 取消关注
  static Future deleteUserStar(int userId) {
    return Application.ajax.delete('user-star',
        data: {'user_id': userId}).then((res) => res.data['data']);
  }
}

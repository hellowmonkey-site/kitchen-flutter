import 'package:get/get.dart';
import 'package:kitchen_flutter/helper/application.dart';
import 'package:kitchen_flutter/model/user_model.dart';
import 'package:kitchen_flutter/provider/person_provider.dart';
import 'package:kitchen_flutter/provider/user_star_provider.dart';
import 'package:provider/provider.dart';

class UserStarItemModel {
  final int id;
  final int userId;
  final int starUserId;
  final String starUserName;
  final String starUserCover;
  final String createdAt;

  UserStarItemModel(
      {this.id = 0,
      this.userId = 0,
      this.starUserId = 0,
      this.starUserName = '',
      this.starUserCover = '',
      this.createdAt = ''});

  UserStarItemModel.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
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
    return Application.ajax.get('user-star').then((res) {
      final data = (res.data['data'] as List)
          .map((e) => UserStarItemModel.fromJson(e))
          .toList();

      // 缓存
      Provider.of<UserStarProvider>(Get.context!, listen: false)
          .setStarList(data);

      // 作者缓存
      Provider.of<PersonProvider>(Get.context!, listen: false).pushPersonList(
          data
              .map((item) => UserModel(
                  id: item.starUserId,
                  username: item.starUserName,
                  nickname: item.starUserName,
                  cover: item.starUserCover,
                  samp: '',
                  token: '',
                  createdAt: ''))
              .toList());

      return data;
    });
  }

  // 添加关注
  static Future postUserStar(int userId) {
    return Application.ajax
        .post('user-star', data: {'user_id': userId}).then((res) {
      getUserStarList();
      return res.data['data'];
    });
  }

  // 取消关注
  static Future deleteUserStar(int userId) {
    final id = Provider.of<UserStarProvider>(Get.context!, listen: false)
        .starList
        .firstWhere((element) => element.starUserId == userId)
        .id;
    return Application.ajax.delete('user-star/$id').then((res) {
      getUserStarList();
      return res.data['data'];
    });
  }
}

import 'package:get/get.dart';
import 'package:kitchen_flutter/helper/application.dart';
import 'package:kitchen_flutter/model/user_favorite_model.dart';
import 'package:kitchen_flutter/model/user_star_model.dart';
import 'package:kitchen_flutter/provider/user_provider.dart';
import 'package:provider/provider.dart';

class UserModel {
  final int id;
  final String username;
  final String? password;
  final String cover;
  final String samp;
  final String nickname;
  final String token;
  final String createdAt;

  UserModel(
      {required this.id,
      required this.username,
      this.cover = '',
      required this.nickname,
      required this.samp,
      required this.token,
      required this.createdAt,
      this.password});

  UserModel.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'],
            username: json['username'],
            cover: json['cover'],
            nickname: json['nickname'],
            samp: json['samp'],
            token: json['token'],
            createdAt: json['created_at']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['cover'] = cover;
    data['nickname'] = nickname;
    data['samp'] = samp;
    data['token'] = token;
    data['created_at'] = createdAt;
    return data;
  }

  // 登录接口
  static Future<UserModel> postLogin(
      {required String username, required String password}) {
    return Application.ajax.post('login',
        data: {'username': username, 'password': password}).then((res) {
      final user = UserModel.fromJson(res.data['data']);
      Provider.of<UserProvider>(Get.context!, listen: false).setUser(user);
      // 获取关注、收藏信息
      UserFavoriteModel.getUserFavoriteList();
      UserStarModel.getUserStarList();
      return user;
    });
  }

  // 获取用户信息
  static Future<UserModel> getUserInfo() {
    return Application.ajax.get('user/info').then((res) {
      final user = UserModel.fromJson(res.data['data']);
      Provider.of<UserProvider>(Get.context!, listen: false).setUser(user);
      // 获取关注、收藏信息
      UserFavoriteModel.getUserFavoriteList();
      UserStarModel.getUserStarList();
      return user;
    });
  }

  // 更新用户信息
  static Future<UserModel> putUserInfo(
      {String? password, String? samp, String? nickname, int? coverId}) {
    return Application.ajax.put('user/info', data: {
      'password': password,
      'samp': samp,
      'nickname': nickname,
      'cover_id': coverId
    }).then((res) {
      final user = UserModel.fromJson(res.data['data']);
      Provider.of<UserProvider>(Get.context!, listen: false).setUser(user);
      return user;
    });
  }
}

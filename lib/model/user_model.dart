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
      {this.id = 0,
      this.username = '',
      this.cover = '',
      this.nickname = '',
      this.samp = '',
      this.token = '',
      this.createdAt = '',
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

  // 获取person信息
  static Future<UserModel> getPersonDetail(int id) {
    return Application.ajax
        .get('person/$id')
        .then((res) => UserModel.fromJson(res.data['data']));
  }

  // 更新用户信息
  static Future<UserModel> putUserInfo(Map<String, dynamic> data) {
    return Application.ajax.put('user/info', data: data).then((res) {
      final user = UserModel.fromJson(res.data['data']);
      Provider.of<UserProvider>(Get.context!, listen: false).setUser(user);
      return user;
    });
  }
}

final defaultUserModel = UserModel();

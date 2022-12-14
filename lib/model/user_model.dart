import 'package:get/get.dart';
import 'package:kitchen_flutter/helper/application.dart';
import 'package:kitchen_flutter/model/page_data_model.dart';
import 'package:kitchen_flutter/model/recipe_model.dart';
import 'package:kitchen_flutter/model/user_favorite_model.dart';
import 'package:kitchen_flutter/model/user_star_model.dart';
import 'package:kitchen_flutter/provider/person_provider.dart';
import 'package:kitchen_flutter/provider/user_provider.dart';
import 'package:provider/provider.dart';

class UserModel {
  final int id;
  final String username;
  final String? password;
  final String cover;
  final int? coverId;
  final String samp;
  final String nickname;
  final String token;
  final String createdAt;

  UserModel(
      {this.id = 0,
      this.username = '',
      this.coverId = 0,
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
            coverId: json['cover_id'],
            nickname: json['nickname'],
            samp: json['samp'],
            token: json['token'],
            createdAt: json['created_at']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['cover'] = cover;
    data['cover_id'] = coverId;
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

      // 作者缓存
      Provider.of<PersonProvider>(Get.context!, listen: false).pushPersonList([
        UserModel(
            id: user.id,
            username: user.username,
            nickname: user.nickname,
            cover: user.cover)
      ]);

      // 获取关注、收藏信息
      UserFavoriteModel.getUserFavoriteList();
      UserStarModel.getUserStarList();

      Application.toast('登录成功');
      return user;
    });
  }

  // 获取用户信息
  static Future getUserInfo() {
    return Application.ajax.get('user/info').then((res) {
      final user = UserModel.fromJson(res.data['data']);

      Provider.of<UserProvider>(Get.context!, listen: false).setUser(user);

      // 作者缓存
      Provider.of<PersonProvider>(Get.context!, listen: false).pushPersonList([
        UserModel(
            id: user.id,
            username: user.username,
            nickname: user.nickname,
            cover: user.cover)
      ]);

      // 获取关注、收藏信息
      UserFavoriteModel.getUserFavoriteList();
      UserStarModel.getUserStarList();
    }).catchError((e) {
      Provider.of<UserProvider>(Get.context!, listen: false)
          .setUser(defaultUserModel);
    });
  }

  // 获取person信息
  static Future<UserModel> getPersonDetail(int id) {
    return Application.ajax.get('person/$id').then((res) {
      final user = UserModel.fromJson(res.data['data']);

      // 作者缓存
      Provider.of<PersonProvider>(Get.context!, listen: false).pushPersonList([
        UserModel(
            id: user.id,
            username: user.username,
            nickname: user.nickname,
            cover: user.cover)
      ]);

      return user;
    });
  }

  // 更新用户信息
  static Future<UserModel> putUserInfo(Map<String, dynamic> data) {
    return Application.ajax.put('user/info', data: data).then((res) {
      final user = UserModel.fromJson(res.data['data']);

      Provider.of<UserProvider>(Get.context!, listen: false).setUser(user);

      // 作者缓存
      Provider.of<PersonProvider>(Get.context!, listen: false).pushPersonList([
        UserModel(
            id: user.id,
            username: user.username,
            nickname: user.nickname,
            cover: user.cover)
      ]);

      return user;
    });
  }

  // 我的主页
  static Future<PageDataModel<RecipeItemModel>> getUserRecipePageList(
      {int page = 1, int? userId}) {
    UserProvider userProvider =
        Provider.of<UserProvider>(Get.context!, listen: false);

    userId ??= userProvider.user.id;

    return RecipeModel.getRecipePageList(page: page, userId: userId)
        .then((data) {
      if (data.page == 1 && userId == userProvider.user.id) {
        userProvider.setUserRecipeList(data.data);
      }
      return data;
    });
  }
}

final defaultUserModel = UserModel();

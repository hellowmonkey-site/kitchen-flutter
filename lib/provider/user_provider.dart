import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kitchen_flutter/helper/application.dart';
import 'package:kitchen_flutter/model/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel _user = defaultUserModel;

  UserProvider() {
    // 初始化
    final data = Application.prefs.getString('user');
    if (data != null) {
      try {
        final userData = json.decode(data);
        if (userData != null && userData['id'] != null && userData['id'] != 0) {
          final user = UserModel.fromJson(userData);
          setUser(user);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  UserModel get user => _user;

  String get token => user.token;

  String get username {
    return user.nickname.isEmpty ? user.username : user.nickname;
  }

  bool get isLogined => token.isNotEmpty;

  setUser(UserModel data) {
    if (data == null || data.id == null || data.id == 0) {
      _user = defaultUserModel;
      Application.prefs.remove('user');
    } else {
      _user = data;
      Application.prefs
          .setString('user', json.encode(_user.toJson()).toString());
    }
    notifyListeners();
  }
}

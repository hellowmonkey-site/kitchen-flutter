import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kitchen_flutter/helper/application.dart';
import 'package:kitchen_flutter/model/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;

  UserProvider() {
    // 初始化
    final data = Application.prefs.getString('user');
    if (data != null) {
      try {
        final userData = json.decode(data);
        final user = UserModel.fromJson(userData);
        setUser(user);
      } catch (e) {
        print(e);
      }
    }
  }

  UserModel? get user => _user;

  String? get token => user?.token;

  String get username {
    if (user == null) {
      return '';
    }
    return user!.nickname == '' ? user!.username : user!.nickname;
  }

  bool get isLogined => token != null;

  setUser(UserModel? data) {
    _user = data;
    if (_user == null) {
      Application.prefs.remove('user');
    } else {
      Application.prefs
          .setString('user', json.encode(_user!.toJson()).toString());
    }
    notifyListeners();
  }
}

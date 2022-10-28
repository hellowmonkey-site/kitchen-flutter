import 'package:flutter/material.dart';
import 'package:kitchen_flutter/model/user_star_model.dart';

class UserStarProvider with ChangeNotifier {
  List<UserStarItemModel> _starList = [];

  List<UserStarItemModel> get starList => _starList;
  List<int> get starUserIds => _starList.map((e) => e.starUserId).toList();

  setStarList(List<UserStarItemModel> data) {
    _starList = data;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:kitchen_flutter/model/user_favorite_model.dart';

class UserFavoriteProvider with ChangeNotifier {
  List<UserFavoriteItemModel> _favoriteList = [];

  List<UserFavoriteItemModel> get favoriteList => _favoriteList;
  List<int> get favoriteRecipeIds =>
      _favoriteList.map((e) => e.recipeId).toList();

  setFavoriteList(List<UserFavoriteItemModel> data) {
    _favoriteList = data;
    notifyListeners();
  }
}

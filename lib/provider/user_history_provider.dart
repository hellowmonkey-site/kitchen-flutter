import 'package:flutter/material.dart';
import 'package:kitchen_flutter/model/user_history_model.dart';

class UserHistoryProvider with ChangeNotifier {
  List<UserHistoryItemModel> _historyList = [];

  List<UserHistoryItemModel> get historyList => _historyList;
  List<int> get historyRecipeIds =>
      _historyList.map((e) => e.recipeId).toList();

  setHistoryList(List<UserHistoryItemModel> data) {
    _historyList = data;
    notifyListeners();
  }
}

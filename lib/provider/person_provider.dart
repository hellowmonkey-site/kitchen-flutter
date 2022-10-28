import 'package:flutter/material.dart';
import 'package:kitchen_flutter/model/user_model.dart';

class PersonProvider with ChangeNotifier {
  List<UserModel> _personList = [];

  List<UserModel> get personList => _personList;

  setPersonList(List<UserModel> data) {
    _personList = data;
    notifyListeners();
  }

  pushPersonList(List<UserModel> data) {
    final list = data
        .where((element) => _personList.every((v) => v.id != element.id))
        .toList();
    setPersonList(list);
  }
}

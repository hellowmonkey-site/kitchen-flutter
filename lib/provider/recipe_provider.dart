import 'package:flutter/material.dart';
import 'package:kitchen_flutter/model/recipe_model.dart';

class RecipeProvider with ChangeNotifier {
  List<RecipeItemModel> _recipeList = [];

  List<RecipeItemModel> get recipeList => _recipeList;

  setRecipeList(List<RecipeItemModel> data) {
    _recipeList = data;
    notifyListeners();
  }

  pushRecipeList(List<RecipeItemModel> data) {
    final list = data
        .where((element) => _recipeList.every((v) => v.id != element.id))
        .toList();
    setRecipeList([..._recipeList, ...list]);
  }
}

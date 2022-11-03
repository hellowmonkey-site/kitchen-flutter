import 'package:flutter/material.dart';
import 'package:kitchen_flutter/model/category_model.dart';
import 'package:kitchen_flutter/model/recipe_model.dart';

class RecipeProvider with ChangeNotifier {
  List<RecipeItemModel> _recipeList = [];

  List<CategoryItemModel> _recipeRandomCategorys = [];

  List<RecipeItemModel> get recipeList => _recipeList;
  List<CategoryItemModel> get recipeRandomCategorys => _recipeRandomCategorys;

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

  setRecipeRandomCategorys(List<CategoryItemModel> data) {
    _recipeRandomCategorys = data;
    notifyListeners();
  }
}

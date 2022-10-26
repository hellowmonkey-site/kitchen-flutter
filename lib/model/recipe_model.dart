import 'package:kitchen_flutter/helper/application.dart';

class RecipeMaterialItemModel {
  final String name;
  final String unit;
  RecipeMaterialItemModel({required this.name, required this.unit});
}

class RecipeStepItemModel {
  final String img;
  final String text;
  RecipeStepItemModel({required this.img, required this.text});
}

class RecipeItemModel {
  final int id;
  final int userId;
  final String userName;
  final String userCover;
  final String title;
  final String samp;
  final String cover;
  final String video;
  final List<RecipeMaterialItemModel> materials;
  final List<RecipeStepItemModel> steps;
  final List<String> categorys;
  final String createdAt;

  RecipeItemModel(
      {required this.id,
      required this.userId,
      required this.userCover,
      required this.categorys,
      required this.cover,
      required this.createdAt,
      required this.materials,
      required this.samp,
      required this.steps,
      required this.title,
      required this.userName,
      required this.video});

  RecipeItemModel.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'],
            userId: json['user_id'],
            userCover: json['user_cover'],
            categorys: json['categorys'],
            cover: json['cover'],
            createdAt: json['created_at'],
            materials: (json['materials'] as List)
                .map((e) =>
                    RecipeMaterialItemModel(name: e['name'], unit: e['unit']))
                .toList(),
            samp: json['samp'],
            steps: (json['steps'] as List)
                .map((e) => RecipeStepItemModel(text: e['text'], img: e['img']))
                .toList(),
            title: json['title'],
            userName: json['user_name'],
            video: json['video']);
}

class RecipeModel {
  static getRecipePageList() {
    return Application.ajax.get('recipe/page-list');
  }
}

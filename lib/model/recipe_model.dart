import 'package:get/get.dart';
import 'package:kitchen_flutter/helper/application.dart';
import 'package:kitchen_flutter/model/page_data_model.dart';
import 'package:kitchen_flutter/provider/recipe_provider.dart';
import 'package:provider/provider.dart';

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
            categorys:
                (json['categorys'] as List).map((e) => e.toString()).toList(),
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
  // 分页获取菜谱
  static Future<PageDataModel<RecipeItemModel>> getRecipePageList(
      {page = 1, String? keywords, String? categorys}) {
    return Application.ajax.get('recipe/page-list', queryParameters: {
      'page': page,
      'keywords': keywords,
      'categorys': categorys
    }).then((res) {
      final data = res.data['data'];
      final list = (data['data'] as List)
          .map((e) => RecipeItemModel.fromJson(e))
          .toList();
      data['data'] = list;

      // 缓存
      Provider.of<RecipeProvider>(Get.context!, listen: false)
          .pushRecipeList(list);

      return PageDataModel.fromJson(data);
    });
  }

  // 获取菜谱详情
  static Future<RecipeItemModel> getRecipeDetail(int id) {
    return Application.ajax.get('recipe/$id').then((res) {
      final data = RecipeItemModel.fromJson(res.data['data']);
      // 缓存
      Provider.of<RecipeProvider>(Get.context!, listen: false)
          .pushRecipeList([data]);
      return data;
    });
  }
}

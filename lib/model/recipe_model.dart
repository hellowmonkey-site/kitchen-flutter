import 'package:get/get.dart';
import 'package:kitchen_flutter/helper/application.dart';
import 'package:kitchen_flutter/model/page_data_model.dart';
import 'package:kitchen_flutter/model/user_model.dart';
import 'package:kitchen_flutter/provider/person_provider.dart';
import 'package:kitchen_flutter/provider/recipe_provider.dart';
import 'package:provider/provider.dart';

class RecipeMaterialItemModel {
  String name;
  String unit;
  RecipeMaterialItemModel({this.name = '', this.unit = ''});
}

class RecipeStepItemModel {
  String img;
  String text;
  RecipeStepItemModel({this.img = '', this.text = ''});
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

  RecipeItemModel({
    this.id = 0,
    this.userId = 0,
    this.userCover = '',
    this.cover = '',
    this.createdAt = '',
    this.samp = '',
    this.title = '',
    this.userName = '',
    this.video = '',
    required this.categorys,
    required this.materials,
    required this.steps,
  });

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

class RecipeInputModel {
  String title;
  String samp;
  String cover;
  String video;
  int coverId;
  int videoId;
  List<RecipeMaterialItemModel> materials;
  List<RecipeStepItemModel> steps;
  List<String> categorys;

  RecipeInputModel({
    this.cover = '',
    this.coverId = 0,
    this.samp = '',
    this.title = '',
    this.video = '',
    this.videoId = 0,
    required this.categorys,
    required this.materials,
    required this.steps,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cover_id'] = coverId;
    data['video_id'] = videoId;
    data['samp'] = samp;
    data['title'] = title;
    data['categorys'] = categorys.map((e) => e.toString()).toList();
    data['materials'] = materials
        .map((item) => ({'name': item.name, 'unit': item.unit}))
        .toList();
    data['steps'] =
        steps.map((item) => ({'text': item.text, 'img': item.img})).toList();
    return data;
  }
}

class RecipeModel {
  // 分页获取菜谱
  static Future<PageDataModel<RecipeItemModel>> getRecipePageList(
      {page = 1, String? keywords, String? categorys, int? userId}) {
    return Application.ajax.get('recipe/page-list', queryParameters: {
      'page': page,
      'keywords': keywords,
      'categorys': categorys,
      'user_id': userId
    }).then((res) {
      final data = res.data['data'];
      final list = (data['data'] as List)
          .map((e) => RecipeItemModel.fromJson(e))
          .toList();
      data['data'] = list;

      // 缓存
      Provider.of<RecipeProvider>(Get.context!, listen: false)
          .pushRecipeList(list);

      // 作者缓存
      Provider.of<PersonProvider>(Get.context!, listen: false).pushPersonList(
          list
              .map((item) => UserModel(
                  id: item.userId,
                  username: item.userName,
                  nickname: item.userName,
                  cover: item.userCover))
              .toList());

      return PageDataModel.fromJson(data);
    });
  }

  // 获取视频地址
  static Future<String> getVideoSrc(int id) {
    return Application.ajax
        .get('recipe/video-src/$id')
        .then((res) => res.data['data'].toString());
  }

  // 获取菜谱详情
  static Future<RecipeItemModel> getRecipeDetail(int id) async {
    final data = await Application.ajax
        .get('recipe/$id')
        .then((res) => res.data['data']);
    if (data['video'] != null && data['video'] != '') {
      try {
        data['video'] = await getVideoSrc(id);
      } catch (e) {}
    }
    final recipe = RecipeItemModel.fromJson(data);
    // 缓存
    Provider.of<RecipeProvider>(Get.context!, listen: false)
        .pushRecipeList([recipe]);

    // 作者缓存
    Provider.of<PersonProvider>(Get.context!, listen: false).pushPersonList([
      UserModel(
          id: recipe.userId,
          username: recipe.userName,
          nickname: recipe.userName,
          cover: recipe.cover)
    ]);
    return recipe;
  }

  // 发布菜谱
  static Future postRecipe(RecipeInputModel input) {
    return Application.ajax
        .post('recipe', data: input.toJson())
        .then((res) => res.data['data']);
  }

  // 删除菜谱
  static Future deleteRecipe(int id) {
    return Application.ajax
        .delete('recipe/$id')
        .then((res) => res.data['data']);
  }
}

final defaultRecipeItemModel =
    RecipeItemModel(categorys: [], materials: [], steps: []);

import 'package:kitchen_flutter/helper/application.dart';

class CategoryItemModel {
  final int id;
  final String name;
  final int parentId;
  final int order;
  final int status;

  CategoryItemModel(
      {required this.id,
      required this.name,
      required this.parentId,
      required this.order,
      required this.status});

  CategoryItemModel.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'],
            parentId: json['parent_id'],
            name: json['name'],
            order: json['order'],
            status: json['status']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['parent_id'] = parentId;
    data['name'] = name;
    data['order'] = order;
    data['status'] = status;
    return data;
  }
}

class CategoryRecommendItemModel {
  final CategoryItemModel parent;
  final List<CategoryItemModel> children;

  CategoryRecommendItemModel({required this.parent, required this.children});

  CategoryRecommendItemModel.fromJson(Map<String, dynamic> json)
      : this(
            children: (json['children'] as List)
                .map((e) => CategoryItemModel.fromJson(e))
                .toList(),
            parent: CategoryItemModel.fromJson(json['parent']));
}

class CategoryModel {
  // 获取分类列表
  static Future<List<CategoryItemModel>> getCategoryList() {
    return Application.ajax.get('category').then((res) {
      return (res.data['data'] as List)
          .map((item) => CategoryItemModel.fromJson(item))
          .toList();
    });
  }

  // 获取分类推荐
  static Future<List<CategoryRecommendItemModel>> getCategoryRecommendList() {
    return Application.ajax.get('category/recommend').then((res) {
      return (res.data['data'] as List)
          .map((item) => CategoryRecommendItemModel.fromJson(item))
          .toList();
    });
  }
}

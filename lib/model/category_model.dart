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

class CategoryModel {
  // 获取分类列表
  static Future<List<CategoryItemModel>> getCategoryList() {
    return Application.ajax.get('category').then((res) {
      return (res.data['data'] as List)
          .map((item) => CategoryItemModel.fromJson(item))
          .toList();
    });
  }
}

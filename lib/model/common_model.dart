import 'package:image_picker/image_picker.dart';
import 'package:kitchen_flutter/config/common.dart';
import 'package:kitchen_flutter/helper/application.dart';
import 'package:dio/dio.dart';

class StorageModel {
  final int id;
  final String url;
  final String filename;
  final String filepath;

  StorageModel(
      {this.id = 0, this.url = '', this.filename = '', this.filepath = ''});

  StorageModel.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'],
            url: json['url'],
            filename: json['filename'],
            filepath: json['filepath']);
}

class AppInfoModel {
  final String version;
  final String appName;
  final String downloadUrl;
  final String description;

  AppInfoModel({
    required this.version,
    required this.appName,
    required this.downloadUrl,
    this.description = '',
  });

  AppInfoModel.fromJson(Map<String, dynamic> json)
      : this(
            version: json['version'],
            appName: json['appName'],
            downloadUrl: appUrl,
            description: json['description']);
}

class CommonModel {
  // 文件上传
  static Future<StorageModel> uploadFile(XFile file, {isImage = true}) async {
    final fileData =
        await MultipartFile.fromFile(file.path, filename: file.name);
    FormData formData =
        FormData.fromMap({'file': fileData, 'is_image': isImage});
    final data = await Application.ajax
        .post('common/upload-file', data: formData)
        .then((res) => StorageModel.fromJson(res.data['data']));
    return data;
  }

  // 检查更新
  static Future<AppInfoModel> getAppInfo() {
    return Application.ajax
        .get('common/app-info')
        .then((res) => AppInfoModel.fromJson(res.data['data']));
  }
}

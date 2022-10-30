import 'package:image_picker/image_picker.dart';
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

class CommonModel {
  // 文件上传
  static Future<StorageModel> uploadFile(XFile file) async {
    final fileData =
        await MultipartFile.fromFile(file.path, filename: file.name);
    FormData formData = FormData.fromMap({'file': fileData});
    final data = await Application.ajax
        .post('common/upload-file', data: formData)
        .then((res) => StorageModel.fromJson(res.data['data']));
    return data;
  }
}

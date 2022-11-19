import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kitchen_flutter/config/common.dart';
import 'package:kitchen_flutter/model/common_model.dart';
import 'package:kitchen_flutter/page/login_page.dart';
import 'package:kitchen_flutter/provider/user_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Application {
  //  请求
  static late Dio ajax;

  //  本地存储
  static late SharedPreferences prefs;

  // 应用信息
  static late PackageInfo packageInfo;

  //  轻提示
  static Function toast(String msg, {Color contentColor = Colors.black87}) {
    return BotToast.showText(
        duration: const Duration(seconds: 2),
        text: msg,
        textStyle: const TextStyle(fontSize: 15, color: Colors.white),
        contentColor: contentColor,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 20));
  }

  // //  轻提示
  // static Function toast(String msg, {Color contentColor = Colors.black87}) {
  //   return BotToast.showText(
  //       text: msg,
  //       contentColor: contentColor,
  //       contentPadding:
  //           const EdgeInsets.symmetric(vertical: 10, horizontal: 20));
  // }

  static openDialog(
      {required String title,
      String? content,
      String cancelText = '取消',
      String confirmText = '确认',
      bool autoClose = true,
      required Function onTap}) {
    List<TextButton> actions = [];
    if (cancelText != '') {
      actions.add(TextButton(
        child: Text(cancelText),
        onPressed: () {
          if (autoClose) {
            Get.back();
          }
          onTap(false);
        },
      ));
    }
    actions.add(TextButton(
        child: Text(confirmText),
        onPressed: () {
          if (autoClose) {
            Get.back();
          }
          onTap(true);
        }));
    Get.generalDialog(
        pageBuilder: (context, anim1, anim2) => Container(),
        transitionBuilder: (context, anim1, anim2, child) {
          return Transform.scale(
              scale: anim1.value,
              child: Opacity(
                opacity: anim1.value,
                child: AlertDialog(
                  elevation: 0,
                  title: Text(
                    title,
                    softWrap: true,
                    style: const TextStyle(fontSize: 18),
                  ),
                  content: content == null
                      ? null
                      : Text(
                          content,
                          softWrap: true,
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black87),
                        ),
                  actions: actions.toList(),
                ),
              ));
        });
  }

  // 链接跳转
  static navigateTo(
    String page, {
    bool auth = false,
  }) {
    final token = Provider.of<UserProvider>(Get.context!, listen: false).token;
    if (auth && token.isEmpty) {
      toast('请先登录');
      return Get.to(() => LoginPage(),
          fullscreenDialog: true, transition: Transition.downToUp);
    }
    return Get.toNamed(page);
  }

  // 打开链接
  static void openUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      toast('无法打开此链接');
    }
  }

  // bottomSheet
  static Future<int?> showBottomSheet(List<String> list) {
    return Get.bottomSheet<int>(
      Container(
        color: Get.isDarkMode
            ? const Color.fromARGB(255, 54, 54, 54)
            : const Color.fromARGB(255, 247, 247, 247),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              child: Column(
                children: list
                    .asMap()
                    .entries
                    .map((item) => InkWell(
                          onTap: () {
                            Get.back(result: item.key);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 1),
                            height: 50,
                            color: Theme.of(Get.context!).bottomAppBarColor,
                            alignment: Alignment.center,
                            child: Text(
                              item.value,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                height: 50,
                color: Theme.of(Get.context!).bottomAppBarColor,
                alignment: Alignment.center,
                child: const Text(
                  '取消',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
      backgroundColor: Get.isDarkMode ? Colors.white24 : Colors.black26,
    );
  }

  // 图片预览-相册
  static showImageGallery(List<String> list, {initIndex = 0}) {
    return Get.to(
        () => Scaffold(
              backgroundColor: Colors.black87,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
              ),
              body: PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  final orgUrl = list[index].split('?').first;
                  final url = '${baseUrl}proxy/image?url=$orgUrl';
                  return PhotoViewGalleryPageOptions(
                      minScale: PhotoViewComputedScale.contained,
                      imageProvider: NetworkImage(url),
                      onTapUp: (context, details, controllerValue) {
                        Get.back();
                      });
                },
                itemCount: list.length,
                loadingBuilder: (context, progress) => const Center(
                  child: LinearProgressIndicator(),
                ),
                pageController: PageController(initialPage: initIndex),
              ),
            ),
        transition: Transition.cupertinoDialog,
        fullscreenDialog: true);
  }

  // 图片预览
  static showImagePreview(String src) {
    final orgUrl = src.split('?').first;
    final url = '${baseUrl}proxy/image?url=$orgUrl';
    return Get.to(
        () => Scaffold(
              backgroundColor: Colors.black87,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
              ),
              body: PhotoView(
                  onTapUp: (context, details, controllerValue) {
                    Get.back();
                  },
                  minScale: PhotoViewComputedScale.contained,
                  imageProvider: NetworkImage(url),
                  loadingBuilder: (context, progress) => const Center(
                        child: LinearProgressIndicator(),
                      )),
            ),
        transition: Transition.cupertinoDialog,
        fullscreenDialog: true);
  }

  // 图片上传
  static Future<StorageModel?> uploadImage() async {
    final ImagePicker imagePicker = ImagePicker();
    try {
      final index = await Application.showBottomSheet(['相册选取', '拍照']);
      if (index == null) {
        return null;
      }
      final XFile? file = await imagePicker.pickImage(
          maxWidth: 1200,
          maxHeight: 1500,
          imageQuality: 80,
          source: index == 0 ? ImageSource.gallery : ImageSource.camera);
      if (file == null) {
        return null;
      }
      final cancel = BotToast.showLoading();
      final data = await CommonModel.uploadFile(file);
      cancel();
      return data;
    } catch (e) {
      Application.toast('上传失败，请使用app重试', contentColor: Colors.red);
    }
    return null;
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitchen_flutter/config/common.dart';

// 图片
cachedNetworkImage(String imageUrl) => CachedNetworkImage(
    imageUrl: imageUrl,
    fit: BoxFit.cover,
    placeholder: (context, url) => const LinearProgressIndicator(),
    errorWidget: (context, url, error) => Image.network(
          fit: BoxFit.cover,
          '${baseUrl}proxy/image?url=$url',
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.black12,
            child: const Icon(
              Icons.error_outline,
              size: 40,
              color: Colors.grey,
            ),
          ),
        ));

// 头像
userAvatar(String cover, {double size = 20}) {
  return ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(size)),
    child: SizedBox(
      width: size,
      height: size,
      child: cachedNetworkImage(cover),
    ),
  );
}

// 列表边框
itemBorder({bool isLast = false}) {
  return Border(
      bottom: BorderSide(
          width: isLast ? 0 : 0.5,
          color: isLast
              ? Colors.transparent
              : Theme.of(Get.context!).disabledColor.withOpacity(0.1)));
}

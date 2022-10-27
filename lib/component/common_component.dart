import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// 图片
cachedNetworkImage(String imageUrl) => CachedNetworkImage(
    imageUrl: imageUrl,
    fit: BoxFit.cover,
    placeholder: (context, url) => const LinearProgressIndicator(),
    errorWidget: (context, url, error) => Container(
          color: Colors.black12,
          child: const Icon(
            Icons.error_outline,
            size: 40,
            color: Colors.grey,
          ),
        ));

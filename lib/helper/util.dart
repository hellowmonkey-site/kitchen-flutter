// 判断数组是否相同
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:kitchen_flutter/config/secret.dart';

// 数组相同
bool listEquals(List<int> a1, List<int> a2) {
  if (a1.length != a2.length) return false;
  for (int i = 0; i < a1.length; i++) {
    if (a1[i] != a2[i]) {
      return false;
    }
  }
  return true;
}

// md5加密
String generateMd5(String data) {
  final content = const Utf8Encoder().convert(data);
  final digest = md5.convert(content).toString();
  return digest;
}

// 加0
String addZero(int num) {
  if (num < 10) {
    return '0$num';
  }
  return num.toString();
}

String generateSecret() {
  final now = DateTime.now();
  final year = now.year.toString();
  final month = addZero(now.month);
  final day = addZero(now.day);
  final hour = addZero(now.hour);
  final data = generateMd5('$csrfSecret-$year$month$day$hour');
  return data;
}

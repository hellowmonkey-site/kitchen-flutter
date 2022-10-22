import 'package:flutter/material.dart';

class PageItem {
  final String text;
  final IconData icon;

  PageItem({required this.text, required this.icon});
}

final List<PageItem> pageList = [
  PageItem(text: '首页', icon: Icons.home),
  PageItem(text: '我的', icon: Icons.person)
];

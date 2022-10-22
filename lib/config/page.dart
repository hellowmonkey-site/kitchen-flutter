import 'package:flutter/material.dart';

class PageItem {
  final String text;
  final IconData icon;

  PageItem({required this.text, required this.icon});
}

final List<PageItem> pageList = [
  PageItem(text: '觅食', icon: Icons.soup_kitchen),
  // PageItem(text: '发布', icon: Icons.add_a_photo),
  PageItem(text: '我的', icon: Icons.person)
];

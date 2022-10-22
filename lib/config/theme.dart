import 'package:flutter/material.dart';

final List<Color> themeColorList = [
  Colors.green,
  Colors.blue,
  Colors.blueGrey,
  Colors.brown,
  Colors.deepPurple,
  Colors.cyan,
  Colors.deepOrange,
  Colors.teal,
  Colors.indigo,
  Colors.pink,
  Colors.red,
  Colors.purple
];

const themeColorDefaultIndex = 2;
const themeModeDefaultIndex = 2;

class ThemeModeItem {
  final ThemeMode value;
  final String text;

  ThemeModeItem({required this.text, required this.value});
}

final List<ThemeModeItem> themeModeList = [
  ThemeModeItem(text: '亮色', value: ThemeMode.light),
  ThemeModeItem(text: '暗色', value: ThemeMode.dark),
  ThemeModeItem(text: '跟随系统', value: ThemeMode.system),
];

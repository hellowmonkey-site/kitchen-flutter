import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitchen_flutter/config/theme.dart';
import 'package:kitchen_flutter/helper/application.dart';

class ThemeProvider with ChangeNotifier {
  static const themeModeIndexText = 'themeModeIndex';
  static const themeColorIndexText = 'themeColorIndex';

  int themeColorIndex = Application.prefs?.getInt(themeColorIndexText) ?? themeColorDefaultIndex;

  int themeModeIndex = Application.prefs?.getInt(themeModeIndexText)?? themeModeDefaultIndex;

  Brightness get themeBrightness {
    var list = [Brightness.light, Brightness.dark];
    if (themeModeIndex == 2) {
      return MediaQuery.of(Get.context!).platformBrightness;
    }
    return list[themeModeIndex];
  }

  changeThemeColor(int index) {
    themeColorIndex = index;
    Application.prefs?.setInt(themeColorIndexText, themeColorIndex);
    notifyListeners();
  }

  changeThemeMode(int index) {
    themeModeIndex = index;
    Application.prefs?.setInt(themeModeIndexText, themeModeIndex);
    notifyListeners();
  }
}

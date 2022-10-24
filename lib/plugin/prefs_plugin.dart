import 'package:kitchen_flutter/helper/application.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsPlugin {
  static Future<void> init() async {
    Application.prefs = await SharedPreferences.getInstance();
  }
}

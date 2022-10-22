import 'package:kitchen_flutter/helper/application.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PrefsPlugin {
  static Future<SharedPreferences> init() {
    return SharedPreferences.getInstance().then((SharedPreferences prefs) {
      Application.prefs = prefs;
      return prefs;
    });
  }
}

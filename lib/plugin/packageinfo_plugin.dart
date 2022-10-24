import 'package:kitchen_flutter/helper/application.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoPlugin {
  static Future<void> init() async {
    Application.packageInfo = await PackageInfo.fromPlatform();
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kitchen_flutter/config/common.dart';
import 'package:kitchen_flutter/config/theme.dart';
import 'package:kitchen_flutter/layout/main_layout.dart';
import 'package:kitchen_flutter/plugin/ajax_plugin.dart';
import 'package:kitchen_flutter/plugin/prefs_plugin.dart';
import 'package:kitchen_flutter/provider/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  //  本地存储
  WidgetsFlutterBinding.ensureInitialized();
  await PrefsPlugin.init();

  //  网络
  AjaxPlugin.init();

  //  设置android状态栏背景透明
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  runApp(MultiProvider(
    providers: [ChangeNotifierProvider.value(value: ThemeProvider())],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final primarySwatch = themeColorList[themeProvider.themeColorIndex] as MaterialColor;
    final themeMode = themeModeList[themeProvider.themeModeIndex];

    return GetMaterialApp(
      title: appTitle,
      // localizationsDelegates: const [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      // ],
      // supportedLocales: const [Locale('zh', 'CN')],
      theme: ThemeData(
          primarySwatch: primarySwatch,
          brightness: Brightness.light,
          backgroundColor: Colors.white),
      darkTheme: ThemeData(
          primarySwatch: primarySwatch,
        brightness: Brightness.dark,
        backgroundColor: Colors.grey[800],
      ),
      themeMode: themeMode.value,
      home: MainLayout(),
    );
  }
}

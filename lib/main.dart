import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kitchen_flutter/config/common.dart';
import 'package:kitchen_flutter/config/route.dart';
import 'package:kitchen_flutter/config/theme.dart';
import 'package:kitchen_flutter/helper/application.dart';
import 'package:kitchen_flutter/layout/main_layout.dart';
import 'package:kitchen_flutter/model/user_model.dart';
import 'package:kitchen_flutter/page/notfound_page.dart';
import 'package:kitchen_flutter/plugin/ajax_plugin.dart';
import 'package:kitchen_flutter/plugin/packageinfo_plugin.dart';
import 'package:kitchen_flutter/plugin/prefs_plugin.dart';
import 'package:kitchen_flutter/provider/theme_provider.dart';
import 'package:kitchen_flutter/provider/user_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  try {
    //  本地存储
    WidgetsFlutterBinding.ensureInitialized();
    await PrefsPlugin.init();

    // 应用信息
    await PackageInfoPlugin.init();

    //  网络
    AjaxPlugin.init();

    // 设置本地用户状态
    final String? data = Application.prefs.getString('user');
    if (data != null) {
      UserModel.getUserInfo().catchError((e) {
        print(e);
      });
    }

    //  设置android状态栏背景透明
    if (!kIsWeb && Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle =
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  } catch (e) {}

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: ThemeProvider()),
      ChangeNotifierProvider.value(value: UserProvider())
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final primarySwatch =
        themeColorList[themeProvider.themeColorIndex] as MaterialColor;
    final themeMode = themeModeList[themeProvider.themeModeIndex];

    return GetMaterialApp(
      title: appTitle,
      // localizationsDelegates: const [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      // ],
      // supportedLocales: const [Locale('zh', 'CN')],
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              shadowColor: Colors.black26,
              elevation: 2),
          primaryColor: primarySwatch,
          primarySwatch: primarySwatch,
          brightness: Brightness.light,
          backgroundColor: Colors.white),
      darkTheme: ThemeData(
        appBarTheme:
            const AppBarTheme(elevation: 0, foregroundColor: Colors.white),
        primaryColor: primarySwatch,
        primarySwatch: primarySwatch,
        brightness: Brightness.dark,
        backgroundColor: Colors.grey[800],
      ),
      themeMode: themeMode.value,
      home: MainLayout(),
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      initialRoute: '/',
      getPages: routePages,
      unknownRoute:
          GetPage(name: '/notfound', page: () => const NotfoundPage()),
    );
  }
}

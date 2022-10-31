import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitchen_flutter/config/common.dart';
import 'package:kitchen_flutter/config/page.dart';
import 'package:kitchen_flutter/config/theme.dart';
import 'package:kitchen_flutter/controller/main_controller.dart';
import 'package:kitchen_flutter/helper/application.dart';
import 'package:kitchen_flutter/page/search_page.dart';
import 'package:kitchen_flutter/page/user_page.dart';
import 'package:kitchen_flutter/provider/theme_provider.dart';
import 'package:provider/provider.dart';

// 记录退出按钮时间
int _last = 0;

class MainLayout extends StatelessWidget {
  MainLayout({super.key});

  final MainController mainController = Get.put(MainController());
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return WillPopScope(
      onWillPop: () {
        int now = DateTime.now().millisecondsSinceEpoch;
        if (now - _last > 1200) {
          Application.toast('在按一次退出');
          _last = DateTime.now().millisecondsSinceEpoch;
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title:
                Obx(() => Text(pageList[mainController.pageIndex.value].text)),
            actions: [
              IconButton(
                  onPressed: () {
                    Get.bottomSheet(
                      Container(
                        // decoration: const BoxDecoration(
                        //     borderRadius: BorderRadius.only(
                        //         topLeft: Radius.circular(10),
                        //         topRight: Radius.circular(10))),
                        color: Theme.of(context).backgroundColor,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(bottom: 10),
                              alignment: Alignment.center,
                              child: const Text(
                                '请选择主题模式',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            ...themeModeList.asMap().entries.map((item) {
                              return CheckboxListTile(
                                secondary: item.value.icon,
                                activeColor: Theme.of(context).primaryColor,
                                title: Text(item.value.text),
                                onChanged: (bool? value) {
                                  themeProvider.changeThemeMode(item.key);
                                  Get.back();
                                },
                                value: themeProvider.themeModeIndex == item.key,
                              );
                            }).toList()
                          ],
                        ),
                      ),
                      backgroundColor:
                          Get.isDarkMode ? Colors.white24 : Colors.black26,
                    );
                  },
                  tooltip: '修改主题模式',
                  icon: Icon(
                      Get.isDarkMode ? Icons.dark_mode : Icons.light_mode)),
              IconButton(
                  onPressed: () {
                    Get.bottomSheet(
                      Container(
                        // decoration: const BoxDecoration(
                        //     borderRadius: BorderRadius.only(
                        //         topLeft: Radius.circular(10),
                        //         topRight: Radius.circular(10))),
                        color: Theme.of(context).backgroundColor,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(bottom: 10),
                              alignment: Alignment.center,
                              child: const Text(
                                '请选择主题颜色',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Expanded(
                                child: SingleChildScrollView(
                                    child: Column(
                              children:
                                  themeColorList.asMap().entries.map((item) {
                                return CheckboxListTile(
                                  secondary: CircleAvatar(
                                    backgroundColor: item.value,
                                  ),
                                  activeColor: Theme.of(context).primaryColor,
                                  title: Text(
                                      '#${item.value.value.toRadixString(16).toUpperCase()}'),
                                  onChanged: (bool? value) {
                                    themeProvider.changeThemeColor(item.key);
                                    Get.back();
                                  },
                                  value:
                                      themeProvider.themeColorIndex == item.key,
                                );
                              }).toList(),
                            )))
                          ],
                        ),
                      ),
                      backgroundColor:
                          Get.isDarkMode ? Colors.white24 : Colors.black26,
                    );
                  },
                  tooltip: '修改主题色',
                  icon: const Icon(Icons.color_lens)),
              if (kIsWeb)
                IconButton(
                    onPressed: () {
                      Application.openUrl(appUrl);
                    },
                    tooltip: 'App下载',
                    icon: const Icon(Icons.file_download_outlined))
              else
                IconButton(
                    onPressed: () {
                      Application.openUrl(webUrl);
                    },
                    tooltip: 'Web端',
                    icon: const Icon(Icons.web))
            ],
          ),
          body: PageView(
            controller: pageController,
            onPageChanged: (int index) {
              mainController.changePageIndex(index);
            },
            children: [SearchPage(), const UserPage()],
          ),
          bottomNavigationBar: AnimatedBottomNavigationBar(
            splashColor: Theme.of(context).primaryColor,
            backgroundColor: Theme.of(context).bottomAppBarColor,
            activeColor: Theme.of(context).primaryColor,
            inactiveColor: Theme.of(context).disabledColor,
            activeIndex: mainController.pageIndex.value,
            onTap: (int index) {
              pageController.jumpToPage(index);
            },
            icons: const [Icons.soup_kitchen, Icons.person],
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.softEdge,
            leftCornerRadius: 20,
            rightCornerRadius: 20,
          ),
          floatingActionButton: FloatingActionButton(
            tooltip: '发布新菜谱',
            onPressed: () {
              Application.navigateTo('/publish', auth: true);
            },
            child: const Icon(Icons.add),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          resizeToAvoidBottomInset: false),
    );
  }
}

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitchen_flutter/config/page.dart';
import 'package:kitchen_flutter/config/theme.dart';
import 'package:kitchen_flutter/controller/main_controller.dart';
import 'package:kitchen_flutter/helper/application.dart';
import 'package:kitchen_flutter/page/publish_page.dart';
import 'package:kitchen_flutter/page/search_page.dart';
import 'package:kitchen_flutter/page/user_page.dart';
import 'package:kitchen_flutter/provider/theme_provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
                    showMaterialModalBottomSheet(
                      animationCurve: Curves.easeInOut,
                      context: context,
                      bounce: true,
                      barrierColor:
                          Get.isDarkMode ? Colors.white24 : Colors.black26,
                      builder: (context) {
                        final int currentIndex = themeProvider.themeModeIndex;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 20),
                                child: Text(
                                  '请选择主题模式',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              ...themeModeList.map((item) {
                                final int index = themeModeList.indexOf(item);
                                return SimpleDialogOption(
                                  onPressed: () {
                                    themeProvider.changeThemeMode(index);
                                    Navigator.of(context).pop();
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        currentIndex == index
                                            ? Icons.check_box
                                            : Icons.check_box_outline_blank,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          child: Text(item.text),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  tooltip: '修改主题模式',
                  icon: Icon(
                      Get.isDarkMode ? Icons.light_mode : Icons.dark_mode)),
              IconButton(
                  onPressed: () {
                    showMaterialModalBottomSheet(
                      animationCurve: Curves.easeInOut,
                      context: context,
                      bounce: true,
                      barrierColor:
                          Get.isDarkMode ? Colors.white24 : Colors.black26,
                      builder: (context) {
                        final int currentIndex = themeProvider.themeModeIndex;
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.9,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 10, bottom: 20),
                                  child: Text(
                                    '请选择主题颜色',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                Expanded(
                                    child: SingleChildScrollView(
                                  controller: ModalScrollController.of(context),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: themeColorList.map((color) {
                                      final int index =
                                          themeColorList.indexOf(color);
                                      return SimpleDialogOption(
                                        onPressed: () {
                                          themeProvider.changeThemeColor(index);
                                          Navigator.of(context).pop();
                                        },
                                        child: Row(children: [
                                          Icon(
                                            currentIndex == index
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 10),
                                              //                                  width: 40,
                                              height: 40,
                                              color: color,
                                            ),
                                          )
                                        ]),
                                      );
                                    }).toList(),
                                  ),
                                ))
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  tooltip: '修改主题色',
                  icon: const Icon(Icons.color_lens))
            ],
          ),
          body: PageView(
            controller: pageController,
            onPageChanged: (int index) {
              mainController.changePageIndex(index);
            },
            children: [SearchPage(), const UserPage()],
          ),
          bottomNavigationBar: Obx(() => AnimatedBottomNavigationBar(
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
                leftCornerRadius: 10,
                rightCornerRadius: 10,
              )),
          floatingActionButton: FloatingActionButton(
            tooltip: '发布新菜谱',
            onPressed: () {
              Application.navigateTo(() => const PublishPage(),
                  fullscreenDialog: true,
                  transition: Transition.downToUp,
                  auth: true);
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(Icons.add),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          resizeToAvoidBottomInset: false),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitchen_flutter/config/page.dart';
import 'package:kitchen_flutter/config/theme.dart';
import 'package:kitchen_flutter/controller/main_controller.dart';
import 'package:kitchen_flutter/helper/application.dart';
import 'package:kitchen_flutter/page/index_page.dart';
import 'package:kitchen_flutter/page/user_page.dart';
import 'package:kitchen_flutter/provider/theme_provider.dart';
import 'package:provider/provider.dart';

// 记录退出按钮时间
int _last = 0;

class MainLayout extends StatelessWidget {
  MainLayout({super.key});

  final MainController controller = Get.put(MainController());
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
          elevation: 0,
          title: Obx(
              () => Text(pageList[controller.pageIndex.value].text)),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        final int currentIndex = themeProvider.themeModeIndex;
                        return SimpleDialog(
                          title: const Text('请选择主题模式'),
                          children: themeModeList.map((item) {
                            final int index = themeModeList.indexOf(item);
                            return SimpleDialogOption(
                              onPressed: () {},
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
                                      margin: const EdgeInsets.only(left: 10),
                                      child: Text(item.text),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      });
                },
                tooltip: '修改主题模式',
                icon:
                    Icon(Get.isDarkMode ? Icons.light_mode : Icons.dark_mode)),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        final currentIndex = themeColorList
                            .indexOf(Theme.of(context).primaryColor);
                        return SimpleDialog(
                          title: const Text('请选择主题颜色'),
                          children: themeColorList.map((color) {
                            final int index = themeColorList.indexOf(color);
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
                                  color: Theme.of(context).primaryColor,
                                ),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 10),
//                                  width: 40,
                                    height: 40,
                                    color: color,
                                  ),
                                )
                              ]),
                            );
                          }).toList(),
                        );
                      });
                },
                tooltip: '修改主题色',
                icon: const Icon(Icons.color_lens))
          ],
        ),
        body: PageView(
          controller: pageController,
          onPageChanged: (int index) {
            controller.changePageIndex(index);
          },
          children: const [IndexPage(), UserPage()],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).bottomAppBarColor,
          shape: const CircularNotchedRectangle(), //shape of notch
          notchMargin:
              5, //notche margin between floating button and bottom appbar
          child: SizedBox(
            height: 55,
            child: Row(
              //children inside bottom appbar
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: (() {
                final List<Widget> list = [];
                for (var item in pageList) {
                  var index = pageList.indexOf(item);
                  list.add(Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Obx(
                        () => TextButton(
                          onPressed: () {
                            pageController.jumpToPage(index);
                          },
                          style: TextButton.styleFrom(
                              foregroundColor:
                                  controller.pageIndex.value == index
                                      ? Theme.of(context).indicatorColor
                                      : Theme.of(context).disabledColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                item.icon,
                                size: 30,
                              ),
                              if (controller.pageIndex.value == index)
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    item.text,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ));
                  if (index == 0) {
                    list.add(const SizedBox(width: 100));
                  }
                }
                return list.toList();
              })(),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

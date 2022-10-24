import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitchen_flutter/helper/application.dart';
import 'package:kitchen_flutter/page/person_page.dart';
import 'package:kitchen_flutter/page/setting_page.dart';
import 'package:kitchen_flutter/page/user_favorite_page.dart';
import 'package:kitchen_flutter/page/user_history_page.dart';
import 'package:kitchen_flutter/page/user_star_page.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                boxShadow: [
                  if (!Get.isDarkMode)
                    BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(.7),
                        blurRadius: 10,
                        offset: const Offset(0, 5))
                ],
                color: Get.isDarkMode
                    ? Theme.of(context).bottomAppBarColor
                    : Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(20)),
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 70,
                  height: 70,
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.amberAccent,
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '用户昵称',
                              maxLines: 1,
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  '描述',
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                ))
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            Application.openDialog(
                                title: '退出登录',
                                onTap: (confirm) {
                                  if (confirm) {
                                    Application.toast('退出~');
                                  }
                                });
                          },
                          icon: const Icon(
                            Icons.exit_to_app,
                            color: Colors.white,
                          ))
                    ],
                  ),
                ))
              ],
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
            controller: ModalScrollController.of(context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  trailing: const Icon(Icons.chevron_right_outlined),
                  leading: const Icon(Icons.home),
                  title: const Text('个人主页'),
                  onTap: () {
                    Get.to(() => const PersonPage(),
                        transition: Transition.cupertino);
                  },
                ),
                ListTile(
                  trailing: const Icon(Icons.chevron_right_outlined),
                  leading: const Icon(Icons.work_history_rounded),
                  title: const Text('浏览记录'),
                  onTap: () {
                    Get.to(() => const UserHistoryPage(),
                        transition: Transition.cupertino);
                  },
                ),
                ListTile(
                  trailing: const Icon(Icons.chevron_right_outlined),
                  leading: const Icon(Icons.favorite),
                  title: const Text('我的收藏'),
                  onTap: () {
                    Get.to(() => const UserFavoritePage(),
                        transition: Transition.cupertino);
                  },
                ),
                ListTile(
                  trailing: const Icon(Icons.chevron_right_outlined),
                  leading: const Icon(Icons.star),
                  title: const Text('我的关注'),
                  onTap: () {
                    Get.to(() => const UserStarPage(),
                        transition: Transition.cupertino);
                  },
                ),
                ListTile(
                  trailing: const Icon(Icons.chevron_right_outlined),
                  leading: const Icon(Icons.settings),
                  title: const Text('账号设置'),
                  onTap: () {
                    Get.to(() => const SettingPage(),
                        transition: Transition.cupertino);
                  },
                ),
                ListTile(
                  trailing: const Icon(Icons.chevron_right_outlined),
                  leading: const Icon(Icons.info),
                  title: const Text('系统版本'),
                  subtitle: Text('1'),
                  onTap: () {
                    Application.toast('检查更新');
                  },
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}

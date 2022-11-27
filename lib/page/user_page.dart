import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitchen_flutter/component/common_component.dart';
import 'package:kitchen_flutter/helper/application.dart';
import 'package:kitchen_flutter/model/common_model.dart';
import 'package:kitchen_flutter/model/user_model.dart';
import 'package:kitchen_flutter/provider/user_provider.dart';
import 'package:provider/provider.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          _userBox(),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  trailing: const Icon(Icons.chevron_right_outlined),
                  leading: const Icon(Icons.home),
                  title: const Text('个人主页'),
                  onTap: () {
                    Application.navigateTo('/person/${userProvider.user.id}',
                        auth: true);
                  },
                ),
                ListTile(
                  trailing: const Icon(Icons.chevron_right_outlined),
                  leading: const Icon(Icons.work_history_rounded),
                  title: const Text('浏览记录'),
                  onTap: () {
                    Application.navigateTo('/user/history', auth: true);
                  },
                ),
                ListTile(
                  trailing: const Icon(Icons.chevron_right_outlined),
                  leading: const Icon(Icons.favorite),
                  title: const Text('我的收藏'),
                  onTap: () {
                    Application.navigateTo('/user/favorite', auth: true);
                  },
                ),
                ListTile(
                  trailing: const Icon(Icons.chevron_right_outlined),
                  leading: const Icon(Icons.star),
                  title: const Text('我的关注'),
                  onTap: () {
                    Application.navigateTo('/user/star', auth: true);
                  },
                ),
                ListTile(
                  trailing: const Icon(Icons.chevron_right_outlined),
                  leading: const Icon(Icons.settings),
                  title: const Text('账号设置'),
                  onTap: () {
                    Application.navigateTo('/setting', auth: true);
                  },
                ),
                ListTile(
                  trailing: const Icon(Icons.chevron_right_outlined),
                  leading: const Icon(Icons.info),
                  title: const Text('系统版本'),
                  subtitle: Text('v ${Application.packageInfo.version}'),
                  onTap: () async {
                    // 检查更新
                    final info = await CommonModel.getAppInfo();
                    if (info.version == Application.packageInfo.version) {
                      Application.toast('已是最新版本');
                    } else {
                      Application.openDialog(
                          title: '发现新版本',
                          content: info.description,
                          confirmText: '立即更新',
                          onTap: (c) {
                            if (c) {
                              Application.openUrl(info.downloadUrl);
                            }
                          });
                    }
                  },
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }

  Widget _userBox() {
    UserProvider userProvider = Provider.of<UserProvider>(Get.context!);

    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            if (!Get.isDarkMode)
              BoxShadow(
                  color: Theme.of(Get.context!).primaryColor.withOpacity(.6),
                  blurRadius: 10,
                  offset: const Offset(0, 3))
          ],
          color: Get.isDarkMode
              ? Theme.of(Get.context!).bottomAppBarColor
              : Theme.of(Get.context!).primaryColor,
          borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 70,
            height: 70,
            child: userProvider.user.cover.isEmpty
                ? const CircleAvatar(
                    backgroundImage: AssetImage(
                      'static/image/splash/logo.png',
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      Application.showImagePreview(userProvider.user.cover);
                    },
                    child: Hero(
                        tag: 'person-item-${userProvider.user.id}',
                        child: userAvatar(userProvider.user.cover, size: 70)),
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
                      Text(
                        userProvider.isLogined ? userProvider.username : '请先登录',
                        maxLines: 1,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            userProvider.isLogined
                                ? userProvider.user.samp.isEmpty
                                    ? '暂无个性签名'
                                    : userProvider.user.samp
                                : '',
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ))
                    ],
                  ),
                ),
                if (userProvider.isLogined)
                  IconButton(
                      onPressed: () {
                        Application.openDialog(
                            title: '退出登录',
                            onTap: (confirm) {
                              if (confirm) {
                                userProvider.setUser(defaultUserModel);
                              }
                            });
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white,
                      ))
                else
                  IconButton(
                      onPressed: () {
                        Get.toNamed('/login');
                      },
                      icon: const Icon(
                        Icons.login,
                        color: Colors.white,
                      ))
              ],
            ),
          ))
        ],
      ),
    );
  }
}

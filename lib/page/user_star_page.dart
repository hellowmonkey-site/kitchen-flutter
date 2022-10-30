import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitchen_flutter/component/common_component.dart';
import 'package:kitchen_flutter/helper/application.dart';
import 'package:kitchen_flutter/model/user_star_model.dart';
import 'package:kitchen_flutter/provider/user_star_provider.dart';
import 'package:provider/provider.dart';

class UserStarPage extends StatelessWidget {
  UserStarPage({Key? key}) : super(key: key);

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    UserStarProvider userStarProvider = Provider.of<UserStarProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的关注'),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: userStarProvider.starList.isEmpty
          ? Center(
              child: Text(
                '暂无数据',
                style: TextStyle(color: Theme.of(context).disabledColor),
              ),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                final item = userStarProvider.starList[index];
                return Container(
                  decoration: BoxDecoration(
                      border: itemBorder(
                          isLast:
                              index == userStarProvider.starList.length - 1)),
                  // padding: const EdgeInsets.only(top: 10),
                  child: ListTile(
                    onTap: () {
                      Get.toNamed('/person/${item.starUserId}');
                    },
                    leading: Hero(
                      tag: 'person-item-${item.starUserId}',
                      child: userAvatar(item.starUserCover, size: 40),
                    ),
                    title: Text(item.starUserName),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(item.createdAt),
                    ),
                    trailing: InkWell(
                      onTap: () async {
                        final index =
                            await Application.showBottomSheet(['取消关注']);
                        if (index == 0) {
                          UserStarModel.deleteUserStar(item.starUserId);
                        }
                      },
                      child: Icon(Icons.more_vert,
                          color: Theme.of(context).disabledColor),
                    ),
                  ),
                );
              },
              itemCount: userStarProvider.starList.length,
              physics: const AlwaysScrollableScrollPhysics(),
              controller: scrollController,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          scrollController.animateTo(0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutQuart);
        },
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }
}

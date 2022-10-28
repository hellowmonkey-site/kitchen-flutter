import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitchen_flutter/component/common_component.dart';
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
      body: ListView.builder(
        itemBuilder: (context, index) {
          final item = userStarProvider.starList[index];
          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ListTile(
              onTap: () {
                Get.toNamed('/person/${item.starUserId}');
              },
              leading: Hero(
                tag: 'person-item-${item.starUserId}',
                child: CircleAvatar(
                  backgroundImage: NetworkImage(item.starUserCover),
                ),
              ),
              title: Text(item.starUserName),
              subtitle: Text(item.createdAt),
              trailing: InkWell(
                onTap: () {
                  Get.bottomSheet(
                    Container(
                      color: Theme.of(context).backgroundColor,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: InkWell(
                              onTap: () {
                                UserStarModel.deleteUserStar(item.starUserId);
                                Get.back();
                              },
                              child: Container(
                                height: 50,
                                color: Theme.of(context).bottomAppBarColor,
                                alignment: Alignment.center,
                                child: const Text(
                                  '取消关注',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              height: 50,
                              color: Theme.of(context).bottomAppBarColor,
                              alignment: Alignment.center,
                              child: const Text(
                                '取消',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    backgroundColor:
                        Get.isDarkMode ? Colors.white24 : Colors.black26,
                  );
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
        backgroundColor: Theme.of(context).primaryColor,
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

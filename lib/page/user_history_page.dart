import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitchen_flutter/component/common_component.dart';
import 'package:kitchen_flutter/controller/user_history_controller.dart';
import 'package:kitchen_flutter/helper/application.dart';
import 'package:kitchen_flutter/model/user_history_model.dart';
import 'package:kitchen_flutter/provider/user_history_provider.dart';
import 'package:provider/provider.dart';

class UserHistoryPage extends StatelessWidget {
  UserHistoryPage({Key? key}) : super(key: key);

  final UserHistoryController userHistoryController =
      Get.put(UserHistoryController());
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    UserHistoryProvider userHistoryProvider =
        Provider.of<UserHistoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('浏览记录'),
        actions: [
          IconButton(
              onPressed: () {
                Application.openDialog(
                    title: '确认清空所有浏览记录吗？',
                    content: '清除后就不再能找回了哦',
                    onTap: (c) {
                      if (c) {
                        UserHistoryModel.clearUserHistory();
                      }
                    });
              },
              icon: const Icon(Icons.delete_outline))
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: userHistoryProvider.historyList.isEmpty
          ? Center(
              child: Text(
                '暂无数据',
                style: TextStyle(color: Theme.of(context).disabledColor),
              ),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                final item = userHistoryProvider.historyList[index];
                return SizedBox(
                  height: 100,
                  // color: Theme.of(context).bottomAppBarColor,
                  child: InkWell(
                    onTap: () {
                      Get.toNamed('/detail/${item.recipeId}');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: itemBorder(
                              isLast: index ==
                                  userHistoryProvider.historyList.length - 1)),
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 130,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Hero(
                                tag: 'recipe-item-${item.recipeId}',
                                child: cachedNetworkImage(item.recipeCover),
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    item.recipeTitle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                          child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.date_range_outlined,
                                            color:
                                                Theme.of(context).disabledColor,
                                            size: 18,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Text(
                                              item.createdAt,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .disabledColor),
                                            ),
                                          )
                                        ],
                                      )),
                                      InkWell(
                                        onTap: () async {
                                          final index =
                                              await Application.showBottomSheet(
                                                  ['删除浏览记录']);
                                          if (index == 0) {
                                            UserHistoryModel.deleteUserHistory(
                                                item.id);
                                          }
                                        },
                                        child: Icon(Icons.more_vert,
                                            color: Theme.of(context)
                                                .disabledColor),
                                      )
                                    ],
                                  )
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: userHistoryProvider.historyList.length,
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

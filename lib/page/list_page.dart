import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitchen_flutter/component/kitchen_item_component.dart';
import 'package:kitchen_flutter/controller/list_controller.dart';
import 'package:kitchen_flutter/controller/search_controller.dart';

class ListPage extends StatelessWidget {
  ListPage({super.key});

  ListController listController = Get.put(ListController());
  SearchController searchController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('菜谱列表'),
        backgroundColor: Theme.of(context).backgroundColor,
        foregroundColor: Get.isDarkMode ? Colors.white : Colors.black,
        shadowColor: Colors.black26,
        elevation: Get.isDarkMode ? 0 : 2,
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        color: Theme.of(context).primaryColor,
        child: Obx(
          () => ListView.builder(
            itemBuilder: (context, index) {
              if (listController.dataList.value.isEmpty) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height - 250,
                  child: Center(
                    child: Text(
                      '暂无数据',
                      style: TextStyle(color: Theme.of(context).disabledColor),
                    ),
                  ),
                );
              } else if (index == listController.dataItemCount - 1) {
                return SizedBox(
                  height: 60,
                  child: Center(
                    child:
                        listController.loading.value && listController.hasMore
                            ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                    Theme.of(context).primaryColor))
                            : !listController.hasMore
                                ? Text(
                                    '暂无更多数据',
                                    style: TextStyle(
                                        color: Theme.of(context).disabledColor),
                                  )
                                : Text(
                                    '上拉加载...',
                                    style: TextStyle(
                                        color: Theme.of(context).disabledColor),
                                  ),
                  ),
                );
              } else {
                return Row(
                  children: const [
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(
                          left: 10, top: 5, bottom: 5, right: 5),
                      child: KitchenItemComponent(),
                    )),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(
                          right: 10, top: 5, bottom: 5, left: 5),
                      child: KitchenItemComponent(),
                    ))
                  ],
                );
              }
            },
            itemCount: listController.dataItemCount,
            physics: const AlwaysScrollableScrollPhysics(),
            controller: listController.scrollController,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {},
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }
}

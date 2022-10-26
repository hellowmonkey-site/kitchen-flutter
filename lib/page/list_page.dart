import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitchen_flutter/component/recipe_item_component.dart';
import 'package:kitchen_flutter/controller/list_controller.dart';

class ListPage extends StatelessWidget {
  ListPage({super.key});

  final ListController listController = Get.put(ListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(listController.searchTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: RefreshIndicator(
          onRefresh: () {
            listController.page.value = 1;
            return listController.fetchData();
          },
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
                        style:
                            TextStyle(color: Theme.of(context).disabledColor),
                      ),
                    ),
                  );
                } else if (index == listController.dataItemCount - 1) {
                  return SizedBox(
                    height: 60,
                    child: Center(
                      child: listController.loading.value &&
                              listController.hasMore
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                                  Theme.of(context).primaryColor))
                          : !listController.hasMore
                              ? Text(
                                  '暂无更多数据',
                                  style: TextStyle(
                                      color: Theme.of(context).disabledColor),
                                )
                              : listController.dataList.value.length > 6
                                  ? Text(
                                      '上拉加载...',
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).disabledColor),
                                    )
                                  : Container(),
                    ),
                  );
                } else {
                  final list = listController.dataList.value;
                  int first = index * 2;
                  int last = first + 1;
                  final item1 = list.elementAt(first);
                  final item2 =
                      last > list.length - 1 ? null : list.elementAt(last);
                  return Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 5),
                        child: RecipeItemComponent(item1),
                      )),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(right: 10, left: 5),
                        child: item2 == null
                            ? Container()
                            : RecipeItemComponent(item2),
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
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          listController.scrollController.animateTo(0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutQuart);
        },
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }
}

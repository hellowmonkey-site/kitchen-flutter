import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitchen_flutter/component/recipe_item_component.dart';
import 'package:kitchen_flutter/model/recipe_model.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  // 数据列表
  List<RecipeItemModel> dataList = [];
  // 分页
  int page = 1;
  int totalPage = 1;

  bool loading = false;

  bool showTopBtn = false;

  // 参数
  final parameters = Get.parameters;

  // 滚动
  final ScrollController scrollController = ScrollController();

  // 标题
  String get searchTitle {
    if ((parameters['keywords'] as String).isEmpty &&
        (parameters['categorys'] as String).isEmpty) {
      return '觅食';
    }
    return [parameters['keywords'], parameters['categorys']]
        .where((element) => element != '')
        .join(',');
  }

  // list渲染时需要的条数
  get dataItemCount => dataList.isEmpty ? 0 : (dataList.length / 2).ceil();

  get hasMore => page < totalPage;

  Future fetchData() {
    setState(() {
      loading = true;
    });
    return RecipeModel.getRecipePageList(
            page: page,
            keywords: parameters['keywords'],
            categorys: parameters['categorys'])
        .then((data) {
      page = data.page;
      totalPage = data.pageCount;
      if (page == 1) {
        dataList = data.data;
      } else {
        dataList = [...dataList, ...data.data];
      }
    }).whenComplete(() {
      loading = false;
      setState(() {});
    });
  }

  @override
  void initState() {
    final cancel = BotToast.showLoading(backgroundColor: Colors.transparent);
    fetchData().whenComplete(() {
      cancel();
    });

    // 监听滚动
    scrollController.addListener(() {
      if (hasMore &&
          scrollController.position.pixels ==
              scrollController.position.maxScrollExtent) {
        page += 1;
        fetchData();
      }
      showTopBtn = scrollController.offset > 1000;
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).bottomAppBarColor,
      appBar: AppBar(
        title: Text(searchTitle),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          page = 1;
          return fetchData();
        },
        color: Theme.of(context).primaryColor,
        child: dataList.isEmpty
            ? SizedBox(
                height: MediaQuery.of(context).size.height - 300,
                child: Center(
                  child: Text(
                    '暂无数据',
                    style: TextStyle(color: Theme.of(context).disabledColor),
                  ),
                ),
              )
            : CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                    int first = index * 2;
                    int last = first + 1;
                    final item1 = dataList.elementAt(first);
                    final item2 = last > dataList.length - 1
                        ? null
                        : dataList.elementAt(last);
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
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
                      ),
                    );
                  }, childCount: dataItemCount)),
                  SliverToBoxAdapter(
                    child: loading && page > 1
                        ? Container(
                            height: 60,
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator())
                        : !hasMore && dataList.isNotEmpty
                            ? Container(
                                height: 60,
                                alignment: Alignment.center,
                                child: Text(
                                  '暂无更多数据',
                                  style: TextStyle(
                                      color: Theme.of(context).disabledColor),
                                ))
                            : null,
                  )
                ],
              ),
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

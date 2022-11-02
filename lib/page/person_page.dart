import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitchen_flutter/component/common_component.dart';
import 'package:kitchen_flutter/component/recipe_item_component.dart';
import 'package:kitchen_flutter/config/common.dart';
import 'package:kitchen_flutter/helper/application.dart';
import 'package:kitchen_flutter/model/recipe_model.dart';
import 'package:kitchen_flutter/model/user_model.dart';
import 'package:kitchen_flutter/model/user_star_model.dart';
import 'package:kitchen_flutter/provider/person_provider.dart';
import 'package:kitchen_flutter/provider/user_star_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class PersonPage extends StatefulWidget {
  const PersonPage({Key? key}) : super(key: key);

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  final ScrollController scrollController = ScrollController();

  final id = int.parse(Get.parameters['id']!);

  var user = defaultUserModel;
  List<RecipeItemModel> dataList = [];

  final double _headerHeight = 80;
  bool loading = false;
  bool overHeader = false;
  int page = 1;
  int totalPage = 1;

  get username => user.nickname.isEmpty ? user.username : user.nickname;

  get hasMore => page < totalPage;

  fetchUserData() async {
    // 填充初始值
    user = Provider.of<PersonProvider>(context, listen: false)
        .personList
        .firstWhere(
          (element) => id == element.id,
          orElse: () => defaultUserModel,
        );
    setState(() {});

    // 获取数据
    user = await UserModel.getPersonDetail(id);
    setState(() {});
  }

  fetchData() {
    setState(() {
      loading = true;
    });
    return RecipeModel.getRecipePageList(userId: id).then((data) {
      page = data.page;
      totalPage = data.pageCount;
      if (page == 1) {
        dataList = data.data;
      } else {
        dataList = [...dataList, ...data.data];
      }
      setState(() {});
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  void initState() {
    fetchUserData();
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
      setState(() {
        overHeader = scrollController.position.pixels > _headerHeight;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserStarProvider userStarProvider = Provider.of<UserStarProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: AnimatedOpacity(
            opacity: overHeader ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: userAvatar(user.cover, size: 30),
                ),
                Text(username),
              ],
            ),
          ),
          elevation: 0,
          actions: [
            if (userStarProvider.starUserIds.contains(user.id))
              IconButton(
                  tooltip: '点击取消关注',
                  onPressed: () {
                    UserStarModel.deleteUserStar(user.id);
                  },
                  icon: const Icon(
                    Icons.star,
                    color: Colors.redAccent,
                  ))
            else
              IconButton(
                  tooltip: '点击关注此作者',
                  onPressed: () {
                    UserStarModel.postUserStar(user.id);
                  },
                  icon: const Icon(Icons.star_border_outlined)),
            IconButton(
              onPressed: () {
                Share.share('【$appTitle】$username',
                    subject: '$webUrl/person/${user.id}');
              },
              icon: const Icon(Icons.share),
              tooltip: '分享',
            )
          ],
        ),
        body: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                color: Theme.of(context).bottomAppBarColor,
                padding: const EdgeInsets.only(
                    top: 5, left: 20, bottom: 20, right: 20),
                child: SizedBox(
                  height: _headerHeight,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: _headerHeight,
                        child: Hero(
                          tag: 'person-item-$id',
                          child: GestureDetector(
                            onTap: () {
                              Application.showImagePreview(user.cover);
                            },
                            child: userAvatar(user.cover, size: _headerHeight),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Text(
                                username,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Application.openDialog(
                                    title: '个性签名',
                                    cancelText: '',
                                    confirmText: '关闭',
                                    content: user.samp,
                                    onTap: (c) {});
                              },
                              child: Text(
                                user.samp,
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).disabledColor,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              dataList.isEmpty
                  ? SizedBox(
                      height: 300,
                      child: Center(
                        child: Text(
                          '暂无数据',
                          style:
                              TextStyle(color: Theme.of(context).disabledColor),
                        ),
                      ),
                    )
                  : Column(
                      children: dataList
                          .sublist(0, (dataList.length / 2).ceil())
                          .asMap()
                          .entries
                          .map((item) {
                        final first = item.key * 2;
                        int last = first + 1;
                        final item1 = dataList.elementAt(first);
                        final item2 = last > dataList.length - 1
                            ? null
                            : dataList.elementAt(last);
                        return Row(
                          children: [
                            Expanded(
                                child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 5),
                              child: RecipeItemComponent(item1),
                            )),
                            Expanded(
                                child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 10, left: 5),
                              child: item2 == null
                                  ? Container()
                                  : RecipeItemComponent(item2),
                            ))
                          ],
                        );
                      }).toList(),
                    ),
              dataList.isEmpty
                  ? Container()
                  : loading
                      ? const CircularProgressIndicator()
                      : !hasMore
                          ? Text(
                              '暂无更多数据',
                              style: TextStyle(
                                  color: Theme.of(context).disabledColor),
                            )
                          : Container(),
              // GridView.count(
              //   crossAxisCount: 2,
              //   mainAxisSpacing: 5,
              //   crossAxisSpacing: 5,
              //   children:
              //       dataList.map((item) => RecipeItemComponent(item)).toList(),
              // )
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
        ));
  }
}

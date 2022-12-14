import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitchen_flutter/component/common_component.dart';
import 'package:kitchen_flutter/helper/application.dart';
import 'package:kitchen_flutter/model/user_favorite_model.dart';
import 'package:kitchen_flutter/provider/user_favorite_provider.dart';
import 'package:provider/provider.dart';

class UserFavoritePage extends StatelessWidget {
  UserFavoritePage({Key? key}) : super(key: key);

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    UserFavoriteProvider userFavoriteProvider =
        Provider.of<UserFavoriteProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的收藏'),
      ),
      backgroundColor:
          Get.isDarkMode ? null : Theme.of(context).backgroundColor,
      body: RefreshIndicator(
        onRefresh: () {
          return UserFavoriteModel.getUserFavoriteList();
        },
        color: Theme.of(context).primaryColor,
        child: userFavoriteProvider.favoriteList.isEmpty
            ? Center(
                child: Text(
                  '暂无数据',
                  style: TextStyle(color: Theme.of(context).disabledColor),
                ),
              )
            : ListView.builder(
                itemBuilder: _itemBuild,
                itemCount: userFavoriteProvider.favoriteList.length,
                physics: const AlwaysScrollableScrollPhysics(),
                controller: scrollController,
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

  Widget _itemBuild(BuildContext context, int index) {
    UserFavoriteProvider userFavoriteProvider =
        Provider.of<UserFavoriteProvider>(context);
    final item = userFavoriteProvider.favoriteList[index];

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
                  isLast:
                      index == userFavoriteProvider.favoriteList.length - 1)),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        item.recipeTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                              child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.date_range_outlined,
                                color: Theme.of(context).disabledColor,
                                size: 18,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  item.createdAt,
                                  style: TextStyle(
                                      color: Theme.of(context).disabledColor,
                                      fontSize: 12),
                                ),
                              )
                            ],
                          )),
                          InkWell(
                            onTap: () async {
                              final index =
                                  await Application.showBottomSheet(['取消收藏']);
                              if (index == 0) {
                                UserFavoriteModel.deleteUserFavorite(
                                    item.recipeId);
                              }
                            },
                            child: Icon(Icons.more_vert,
                                color: Theme.of(context).disabledColor),
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
  }
}

import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitchen_flutter/component/common_component.dart';
import 'package:kitchen_flutter/config/common.dart';
import 'package:kitchen_flutter/helper/application.dart';
import 'package:kitchen_flutter/model/recipe_model.dart';
import 'package:kitchen_flutter/model/user_favorite_model.dart';
import 'package:kitchen_flutter/model/user_star_model.dart';
import 'package:kitchen_flutter/provider/recipe_provider.dart';
import 'package:kitchen_flutter/provider/user_favorite_provider.dart';
import 'package:kitchen_flutter/provider/user_provider.dart';
import 'package:kitchen_flutter/provider/user_star_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
  // 滚动
  final ScrollController scrollController = ScrollController();

  final id = int.parse(Get.parameters['id']!);

  double headerHeight = 350;

  // 是否可以播放视频
  var canPlayVideo = false;

  var data = defaultRecipeItemModel;

  bool overHeader = false;

  bool showTopBtn = false;

  fetchData() async {
    // 填充初始值
    data = Provider.of<RecipeProvider>(context, listen: false)
        .recipeList
        .firstWhere(
          (element) => id == element.id,
          orElse: () => defaultRecipeItemModel,
        );
    setState(() {});

    if (data.id == 0) {
      BotToast.showLoading(backgroundColor: Colors.transparent);
    }
    try {
      // 获取数据
      data = await RecipeModel.getRecipeDetail(id);
      setState(() {});

      if (data.video.isNotEmpty) {
        if (videoPlayerController != null) {
          videoPlayerController!.dispose();
        }
        videoPlayerController = VideoPlayerController.network(data.video);
        await videoPlayerController!.initialize();
        await Future.delayed(const Duration(milliseconds: 100));

        if (!kIsWeb) {
          if (chewieController != null) {
            chewieController!.dispose();
          }
          chewieController = ChewieController(
              // aspectRatio: 1,
              videoPlayerController: videoPlayerController!,
              // placeholder: Image.network(data.cover),
              showControls: true,
              materialProgressColors: ChewieProgressColors(
                  playedColor:
                      Theme.of(Get.context!).primaryColor.withOpacity(0.8)),
              playbackSpeeds: const [
                0.5,
                1,
                1.25,
                1.5,
                1.75,
                2,
                2.25,
                2.5,
                2.75,
                3
              ]);
        }
        setState(() {
          canPlayVideo = true;
          overHeader = true;
          headerHeight = MediaQuery.of(context).size.width /
              videoPlayerController!.value.aspectRatio;
        });

        await videoPlayerController!.play();
      }

      setState(() {});
    } on DioError catch (e) {
      if (e.error['status'] == 10001) {
        Get.back(result: 2);
      }
    } finally {
      BotToast.closeAllLoading();
    }
  }

  @override
  void initState() {
    fetchData();

    // 监听滚动
    scrollController.addListener(() {
      if (!canPlayVideo) {
        overHeader = scrollController.position.pixels > headerHeight;
      }
      showTopBtn = scrollController.offset > 500;
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (videoPlayerController != null) {
      videoPlayerController!.dispose();
    }
    if (chewieController != null) {
      chewieController!.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: !canPlayVideo,
      appBar: AppBar(
        foregroundColor: overHeader ? null : Colors.white,
        title: overHeader
            ? Text(
                data.title,
              )
            : null,
        backgroundColor:
            Theme.of(context).bottomAppBarColor.withOpacity(overHeader ? 1 : 0),
        elevation: (Get.isDarkMode || !overHeader) ? 0 : 2,
        actions: _actions(),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _header(),
              Container(
                padding: const EdgeInsets.all(20),
                color: Theme.of(context).bottomAppBarColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        data.title,
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          color:
                              Theme.of(context).shadowColor.withOpacity(0.05),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Text(data.samp),
                    ),
                    _person(),
                    ..._materials(),
                    ...data.steps
                        .asMap()
                        .entries
                        .map((item) => _stepItem(item))
                        .toList(),
                    Wrap(
                      spacing: 10,
                      runSpacing: kIsWeb ? 10 : 0,
                      alignment: WrapAlignment.start,
                      children: data.categorys
                          .map((str) => OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)))),
                                child: Text(str),
                                onPressed: () {
                                  Get.toNamed('/list?categorys=$str');
                                },
                              ))
                          .toList(),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: showTopBtn
          ? FloatingActionButton(
              onPressed: () {
                scrollController.animateTo(0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutQuart);
              },
              child: const Icon(Icons.arrow_upward))
          : null,
    );
  }

  Widget _header() {
    return SizedBox(
      height: headerHeight,
      child: Hero(
        tag: 'recipe-item-$id',
        child: canPlayVideo
            ? (kIsWeb
                ? Stack(
                    children: [
                      VideoPlayer(videoPlayerController!),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(videoPlayerController!.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow),
                          onPressed: () {
                            setState(() {
                              videoPlayerController!.value.isPlaying
                                  ? videoPlayerController!.pause()
                                  : videoPlayerController!.play();
                            });
                          },
                        ),
                      )
                    ],
                  )
                : Chewie(
                    controller: chewieController!,
                  ))
            : (data.cover.isEmpty
                ? Center(
                    child: Text(
                      '暂无封面',
                      style: TextStyle(
                          fontSize: 12, color: Theme.of(context).disabledColor),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      Application.showImagePreview(data.cover);
                    },
                    child: cachedNetworkImage(data.cover),
                  )),
      ),
    );
  }

  Widget _person() {
    UserStarProvider userStarProvider = Provider.of<UserStarProvider>(context);

    return GestureDetector(
      onTap: () {
        Get.toNamed('/person/${data.userId}');
      },
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).shadowColor.withOpacity(0.05),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        margin: const EdgeInsets.only(bottom: 30),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Row(
                children: [
                  Hero(
                    tag: 'person-item-${data.userId}',
                    child: userAvatar(data.userCover, size: 40),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(data.userName),
                  )
                ],
              )),
              if (userStarProvider.starUserIds.contains(data.userId))
                IconButton(
                    tooltip: '点击取消关注',
                    onPressed: () {
                      UserStarModel.deleteUserStar(data.userId);
                    },
                    icon: const Icon(
                      Icons.star,
                      color: Colors.redAccent,
                    ))
              else
                IconButton(
                    tooltip: '点击关注此作者',
                    onPressed: () {
                      UserStarModel.postUserStar(data.userId);
                    },
                    icon: const Icon(Icons.star_border_outlined))
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _materials() {
    return [
      const Padding(
        padding: EdgeInsets.only(bottom: 15),
        child: Text(
          '用料',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          children: data.materials
              .asMap()
              .entries
              .map((item) => Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                        border: itemBorder(
                            isLast: item.key == data.materials.length - 1)),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          item.value.name,
                          style: const TextStyle(fontSize: 16),
                        )),
                        if (item.value.unit.isNotEmpty)
                          SizedBox(
                            width: 120,
                            child: Text(
                              item.value.unit,
                              style: const TextStyle(fontSize: 16),
                            ),
                          )
                      ],
                    ),
                  ))
              .toList(),
        ),
      )
    ];
  }

  Widget _stepItem(MapEntry<int, RecipeStepItemModel> item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Text(
            '步骤 ${item.key + 1}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        if (item.value.img.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: GestureDetector(
              onTap: () {
                Application.showImageGallery(
                    data.steps.map((e) => e.img).toList(),
                    initIndex: item.key);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 150),
                  child: cachedNetworkImage(item.value.img),
                ),
              ),
            ),
          ),
        if (item.value.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Text(
              item.value.text,
              style: const TextStyle(fontSize: 16),
            ),
          )
      ],
    );
  }

  List<Widget> _actions() {
    UserFavoriteProvider userFavoriteProvider =
        Provider.of<UserFavoriteProvider>(context);

    return [
      if (userFavoriteProvider.favoriteRecipeIds.contains(id))
        IconButton(
            tooltip: '点击取消收藏',
            onPressed: () {
              UserFavoriteModel.deleteUserFavorite(id);
            },
            icon: const Icon(
              Icons.favorite,
              color: Colors.redAccent,
            ))
      else
        IconButton(
            tooltip: '点击添加收藏',
            onPressed: () {
              UserFavoriteModel.postUserFavorite(id);
            },
            icon: const Icon(
              Icons.favorite_border_outlined,
            )),
      IconButton(
        onPressed: () {
          Share.share('【$appTitle】${data.title} <$webUrl#/detail/$id>',
              subject: data.userName);
        },
        icon: const Icon(Icons.share),
        tooltip: '分享',
      ),
      if (Provider.of<UserProvider>(context, listen: false).user.id ==
          data.userId)
        IconButton(
          onPressed: () {
            Application.openDialog(
              title: '确认要删除此菜谱？',
            ).then((c) {
              if (c != null) {
                RecipeModel.deleteRecipe(data.id).then((value) {
                  Get.back(result: 1);
                });
              }
            });
          },
          icon: const Icon(Icons.delete_outline),
          tooltip: '删除',
        )
    ];
  }
}

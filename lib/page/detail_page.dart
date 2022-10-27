import 'dart:math';

import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitchen_flutter/component/common_component.dart';
import 'package:kitchen_flutter/controller/list_controller.dart';
import 'package:kitchen_flutter/helper/application.dart';
import 'package:kitchen_flutter/model/recipe_model.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:video_player/video_player.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late final ListController listController;
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
  // 滚动
  final ScrollController scrollController = ScrollController();

  final id = int.parse(Get.parameters['id']!);

  final double headerHeight = 350;

  var data = RecipeItemModel(
      id: 0,
      userId: 0,
      userCover: '',
      userName: '',
      categorys: [],
      cover: '',
      createdAt: '',
      materials: [],
      samp: '',
      steps: [],
      title: '',
      video: '');

  double opacity = 0;

  // 是否可以播放视频
  get canPlayVideo {
    return data.video.isNotEmpty &&
        videoPlayerController != null &&
        videoPlayerController!.value.isInitialized;
  }

  bool onNotification(ScrollNotification notification) {
    double progress = notification.metrics.pixels / headerHeight;
    if (!canPlayVideo && (opacity != 1 || progress <= 1)) {
      setState(() {
        opacity = min(progress, 1);
      });
    }
    return false;
  }

  fetchData() async {
    try {
      listController = Get.find<ListController>();
      // 填充初始值
      data = listController.dataList.value.firstWhere(
        (element) => id == element.id,
        orElse: () => data,
      );
      setState(() {});
    } catch (e) {}

    // 获取数据
    data = await RecipeModel.getRecipeDetail(id);
    setState(() {});

    if (data.video.isNotEmpty) {
      videoPlayerController = VideoPlayerController.network(data.video);
      await videoPlayerController!.initialize();
      if (!kIsWeb) {
        chewieController = ChewieController(
            // aspectRatio: 1,
            videoPlayerController: videoPlayerController!,
            // placeholder: Image.network(data.cover),
            showControls: true,
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
      videoPlayerController!.play();
    }

    setState(() {});

    if (canPlayVideo) {
      setState(() {
        opacity = 1;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    fetchData();
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
        title: Text(
          data.title,
          style: TextStyle(
              color: Theme.of(context)
                  .appBarTheme
                  .foregroundColor
                  ?.withOpacity(opacity)),
        ),
        backgroundColor:
            Theme.of(context).bottomAppBarColor.withOpacity(opacity),
        elevation: Get.isDarkMode ? 0 : opacity * 2,
        actions: [
          IconButton(
              tooltip: '收藏',
              onPressed: () {},
              icon: const Icon(
                Icons.favorite,
                color: Colors.redAccent,
              )),
          IconButton(
            onPressed: () {
              Application.navigateTo('/publish', auth: true);
            },
            icon: const Icon(Icons.add),
            tooltip: '照着做',
          )
        ],
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: onNotification,
        child: SingleChildScrollView(
          controller: scrollController,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: headerHeight,
                  child: Hero(
                    tag: 'recipe-item-${data.id}',
                    child: canPlayVideo
                        ? Container(
                            // height: headerHeight,
                            color: Colors.black,
                            child: (kIsWeb
                                ? VideoPlayer(videoPlayerController!)
                                : Chewie(
                                    controller: chewieController!,
                                  )),
                          )
                        : cachedNetworkImage(data.cover),
                  ),
                ),
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
                      Container(
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).shadowColor.withOpacity(0.05),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        margin: const EdgeInsets.only(bottom: 30),
                        child: InkWell(
                          onTap: () {
                            Get.toNamed('/person/${data.userId}');
                          },
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
                                    CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(data.userCover),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(data.userName),
                                    )
                                  ],
                                )),
                                IconButton(
                                    onPressed: () {},
                                    icon:
                                        const Icon(Icons.star_border_outlined))
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: Text(
                          '用料',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Column(
                          children: data.materials
                              .asMap()
                              .entries
                              .map((item) => Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                      width:
                                          item.key == data.materials.length - 1
                                              ? 0
                                              : 1,
                                      color: Theme.of(context)
                                          .shadowColor
                                          .withOpacity(0.05),
                                    ))),
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
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          )
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                      ...data.steps
                          .asMap()
                          .entries
                          .map((item) => Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: Text(
                                      '步骤 ${item.key + 1}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(
                                            () => Scaffold(
                                                  backgroundColor:
                                                      Colors.black87,
                                                  extendBodyBehindAppBar: true,
                                                  appBar: AppBar(
                                                    elevation: 0,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    foregroundColor:
                                                        Colors.white,
                                                  ),
                                                  body:
                                                      PhotoViewGallery.builder(
                                                    scrollPhysics:
                                                        const BouncingScrollPhysics(),
                                                    builder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return PhotoViewGalleryPageOptions(
                                                        imageProvider:
                                                            NetworkImage(data
                                                                .steps[index]
                                                                .img),
                                                      );
                                                    },
                                                    itemCount:
                                                        data.steps.length,
                                                    loadingBuilder:
                                                        (context, progress) =>
                                                            const Center(
                                                      child:
                                                          LinearProgressIndicator(),
                                                    ),
                                                    pageController:
                                                        PageController(
                                                            initialPage:
                                                                item.key),
                                                    // onPageChanged: (i) {},
                                                  ),
                                                ),
                                            transition:
                                                Transition.cupertinoDialog,
                                            fullscreenDialog: true);
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child:
                                            cachedNetworkImage(item.value.img),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        bottom:
                                            item.key == data.steps.length - 1
                                                ? 0
                                                : 30),
                                    child: Text(
                                      item.value.text,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  )
                                ],
                              ))
                          .toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          // web端是控制播放的按钮
          // app是返回顶部按钮
          if (data.video.isNotEmpty && kIsWeb) {
            setState(() {
              videoPlayerController!.value.isPlaying
                  ? videoPlayerController!.pause()
                  : videoPlayerController!.play();
            });
          } else {
            scrollController.animateTo(0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutQuart);
          }
        },
        child: Icon(data.video.isNotEmpty && kIsWeb
            ? (videoPlayerController!.value.isPlaying
                ? Icons.pause
                : Icons.play_arrow)
            : Icons.arrow_upward),
      ),
    );
  }
}

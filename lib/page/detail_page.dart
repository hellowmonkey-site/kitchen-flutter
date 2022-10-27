import 'dart:math';

import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitchen_flutter/component/common_component.dart';
import 'package:kitchen_flutter/controller/list_controller.dart';
import 'package:kitchen_flutter/model/recipe_model.dart';
import 'package:video_player/video_player.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late final ListController listController;
  late final VideoPlayerController videoPlayerController;
  late final ChewieController chewieController;
  // 滚动
  final ScrollController scrollController = ScrollController();

  final id = int.parse(Get.parameters['id']!);

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

  bool onNotification(ScrollNotification notification) {
    double progress = notification.metrics.pixels / 200;

    setState(() {
      opacity = min(progress, 1);
    });
    return false;
  }

  @override
  void initState() async {
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

    videoPlayerController = VideoPlayerController.network(data.video);
    await videoPlayerController.initialize();

    chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        placeholder: Image.network(data.cover),
        playbackSpeeds: const [0.5, 1, 1.25, 1.5, 1.75, 2, 2.25, 2.5, 2.75, 3]);

    videoPlayerController.play();

    setState(() {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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
            Theme.of(context).appBarTheme.backgroundColor!.withOpacity(opacity),
        elevation: Get.isDarkMode ? 0 : opacity * 2,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.favorite_border_outlined))
        ],
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: onNotification,
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 350,
                  child: Hero(
                    tag: 'recipe-item-${data.id}',
                    child: data.video != '' &&
                            videoPlayerController.value.isInitialized
                        ? (kIsWeb
                            ? VideoPlayer(videoPlayerController)
                            : Chewie(
                                controller: chewieController,
                              ))
                        : cachedNetworkImage(data.cover),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Theme.of(context).bottomAppBarColor,
                      border: Border(
                          bottom: BorderSide(
                              color: Theme.of(context)
                                  .inputDecorationTheme
                                  .border!
                                  .borderSide
                                  .color))),
                  alignment: Alignment.center,
                  child: Text(
                    data.title,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  margin: const EdgeInsets.only(bottom: 20),
                  color: Theme.of(context).bottomAppBarColor,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(data.userCover),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(data.userName,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).disabledColor)),
                          )
                        ],
                      )),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.star))
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // web端是控制播放的按钮
          // app是返回顶部按钮
          if (data.video != '' && kIsWeb) {
            setState(() {
              videoPlayerController.value.isPlaying
                  ? videoPlayerController.pause()
                  : videoPlayerController.play();
            });
          } else {
            scrollController.animateTo(0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutQuart);
          }
        },
        child: Icon(data.video != '' && kIsWeb
            ? (videoPlayerController.value.isPlaying
                ? Icons.pause
                : Icons.play_arrow)
            : Icons.arrow_upward),
      ),
    );
  }
}

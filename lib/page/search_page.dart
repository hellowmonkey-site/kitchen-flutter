import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitchen_flutter/controller/search_controller.dart';
import 'package:kitchen_flutter/helper/application.dart';
import 'package:kitchen_flutter/page/list_page.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});

  final SearchController searchController = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController.textController,
                      textInputAction: TextInputAction.search,
                      textCapitalization: TextCapitalization.sentences,
                      cursorWidth: 3,
                      // cursorColor: Colors.white,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                          labelText: '搜菜谱',
                          fillColor: Theme.of(context).bottomAppBarColor,
                          hintText: '搜菜谱...',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            textBaseline: TextBaseline.ideographic,
                          ),
                          prefixIcon: const Icon(Icons.manage_search_rounded),
                          filled: true,
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              borderSide: BorderSide(
                                  style: BorderStyle.solid, width: 2))),
                      onChanged: (val) {
                        searchController.keywords.value = val;
                      },
                      // onSubmitted: onSubmitted,
                    ),
                  ),
                  Obx(() => (searchController.keywords.value.isEmpty &&
                          searchController.selectedCategory.value.isEmpty
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: MaterialButton(
                              textColor: Colors.white,
                              elevation: 0,
                              height: 63,
                              minWidth: 63,
                              color: Theme.of(context).primaryColor,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              padding: const EdgeInsets.all(0),
                              onPressed: () {
                                Application.navigateTo(() => ListPage());
                              },
                              child: const Icon(
                                Icons.search,
                                size: 24,
                              )),
                        )))
                ],
              ),
              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                alignment: Alignment.center,
                child: const Text(
                  '冰箱里有什么？',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                    child: Obx(() => Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: searchController.recommendCategorys.value
                              .map((item) => Container(
                                    margin: const EdgeInsets.only(bottom: 15),
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Theme.of(context)
                                            .bottomAppBarColor),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Container(
                                          padding:
                                              const EdgeInsets.only(bottom: 15),
                                          alignment: Alignment.center,
                                          child: Text(
                                            item.parent.name,
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        Wrap(
                                          spacing: 10,
                                          runSpacing: 10,
                                          alignment: WrapAlignment.start,
                                          children: item.children
                                              .map((child) => TextButton(
                                                  style: TextButton.styleFrom(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 5,
                                                          horizontal: 15),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                      backgroundColor:
                                                          searchController
                                                                  .selectedCategory
                                                                  .value
                                                                  .contains(
                                                                      child
                                                                          .name)
                                                              ? Theme.of(
                                                                      context)
                                                                  .primaryColor
                                                              : Get.isDarkMode
                                                                  ? Colors
                                                                      .white12
                                                                  : Colors
                                                                      .black12),
                                                  onPressed: () {
                                                    searchController
                                                        .changeCategory(
                                                            child.name);
                                                  },
                                                  child: Text(
                                                    child.name,
                                                    style: TextStyle(
                                                        color: searchController
                                                                .selectedCategory
                                                                .value
                                                                .contains(
                                                                    child.name)
                                                            ? Colors.white
                                                            : Theme.of(context)
                                                                .appBarTheme
                                                                .foregroundColor),
                                                  )))
                                              .toList(),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ))),
              )
            ],
          ),
        ),
        resizeToAvoidBottomInset: false);
  }
}

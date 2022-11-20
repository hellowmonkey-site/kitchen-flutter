import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitchen_flutter/controller/search_controller.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});

  final SearchController searchController = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Stack(
                    children: [
                      TextField(
                        focusNode: searchController.focusNode,
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
                        onSubmitted: (v) {
                          searchController.handleSearch();
                        },
                        // onSubmitted: onSubmitted,
                      ),
                      Positioned(
                          right: 10,
                          top: 0,
                          bottom: 0,
                          child: Obx(() => AnimatedOpacity(
                                opacity: searchController.canSearch ? 0 : 1,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOutCirc,
                                child: Center(
                                  child: TextButton(
                                      onPressed: () {
                                        Get.toNamed('/list');
                                      },
                                      child: const Text('去觅食')),
                                ),
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
                        child: Obx(() => Padding(
                              padding: EdgeInsets.only(
                                  bottom: searchController.canSearch ? 100 : 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: searchController
                                    .recommendCategorys.value
                                    .map((item) => Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 15),
                                          padding: const EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Theme.of(context)
                                                  .bottomAppBarColor),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    bottom: 15),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  item.parent.name,
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                ),
                                              ),
                                              Wrap(
                                                spacing: 10,
                                                runSpacing: 10,
                                                alignment: WrapAlignment.start,
                                                children: item.children
                                                    .map((child) => FilterChip(
                                                        avatar: CircleAvatar(
                                                            backgroundColor: Theme
                                                                    .of(context)
                                                                .primaryColor
                                                                .withOpacity(
                                                                    0.3)),
                                                        selectedColor:
                                                            Theme.of(context)
                                                                .primaryColor,
                                                        label: Text(
                                                          child.name,
                                                          style: TextStyle(
                                                              color: !Get.isDarkMode &&
                                                                      searchController
                                                                          .selectedCategory
                                                                          .value
                                                                          .contains(
                                                                              child.name)
                                                                  ? Colors.white
                                                                  : null),
                                                        ),
                                                        selected:
                                                            searchController
                                                                .selectedCategory
                                                                .value
                                                                .contains(
                                                                    child.name),
                                                        onSelected: (checked) {
                                                          searchController
                                                              .changeCategory(
                                                                  child.name);
                                                        }))
                                                    .toList(),
                                              ),
                                            ],
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ))),
                  )
                ],
              ),
            ),
            Obx(() => AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.bounceInOut,
                bottom: searchController.canSearch ? 40 : -80,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          searchController.handleClear();
                        },
                        style: ElevatedButton.styleFrom(
                            foregroundColor:
                                Theme.of(context).appBarTheme.foregroundColor,
                            backgroundColor:
                                Theme.of(context).bottomAppBarColor,
                            shadowColor: Theme.of(context).shadowColor,
                            elevation: 15,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            padding: const EdgeInsets.symmetric(vertical: 18)),
                        // ignore: prefer_const_constructors
                        child: Icon(
                          Icons.cleaning_services_outlined,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          searchController.handleSearch();
                        },
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            shadowColor: Theme.of(context).primaryColor,
                            elevation: 15,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            padding: const EdgeInsets.symmetric(vertical: 18)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: const [
                            Icon(
                              Icons.manage_search_outlined,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                '去觅食',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ))),
          ],
        ),
        resizeToAvoidBottomInset: false);
  }
}

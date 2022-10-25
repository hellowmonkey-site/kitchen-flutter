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
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                      decoration: const InputDecoration(
                          labelText: '搜菜谱',
                          fillColor: Colors.transparent,
                          hintText: '搜菜谱...',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            textBaseline: TextBaseline.ideographic,
                          ),
                          prefixIcon: Icon(Icons.manage_search_rounded),
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  style: BorderStyle.solid, width: 2))),
                      onChanged: (val) {
                        searchController.keywords.value = val;
                      },
                      // onSubmitted: onSubmitted,
                    ),
                  ),
                  Obx(() => (searchController.keywords.value.isEmpty
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
                                      BorderRadius.all(Radius.circular(10))),
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SingleChildScrollView(
                    child: Obx(() => Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.center,
                        children: searchController.hotCategorys
                            .map((item) => MaterialButton(
                                  onPressed: () {},
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  color: Theme.of(context).backgroundColor,
                                  textColor: Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 1),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Text(item.name),
                                ))
                            .toList())),
                  ),
                ),
              )
            ],
          ),
        ),
        resizeToAvoidBottomInset: false);
  }
}

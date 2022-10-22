import 'package:get/get.dart';

class MainController extends GetxController {
  var pageIndex = Rx<int>(0);

  changePageIndex(int index) {
    pageIndex.value = index;
  }
}

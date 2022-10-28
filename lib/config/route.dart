import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:kitchen_flutter/page/detail_page.dart';
import 'package:kitchen_flutter/page/list_page.dart';
import 'package:kitchen_flutter/page/login_page.dart';
import 'package:kitchen_flutter/page/person_page.dart';
import 'package:kitchen_flutter/page/publish_page.dart';
import 'package:kitchen_flutter/page/search_page.dart';
import 'package:kitchen_flutter/page/setting_page.dart';
import 'package:kitchen_flutter/page/user_favorite_page.dart';
import 'package:kitchen_flutter/page/user_history_page.dart';
import 'package:kitchen_flutter/page/user_page.dart';
import 'package:kitchen_flutter/page/user_star_page.dart';

final routePages = [
  GetPage(
      name: '/search',
      page: () => SearchPage(),
      transition: Transition.cupertino,
      curve: Curves.easeInOut),
  GetPage(
      name: '/user',
      page: () => const UserPage(),
      transition: Transition.cupertino,
      curve: Curves.easeInOut),
  GetPage(
      name: '/detail/:id',
      page: () => const DetailPage(),
      transition: Transition.cupertino,
      curve: Curves.easeInOut),
  GetPage(
      name: '/list',
      page: () => ListPage(),
      transition: Transition.cupertino,
      curve: Curves.easeInOut),
  GetPage(
      name: '/login',
      page: () => LoginPage(),
      transition: Transition.cupertino,
      curve: Curves.easeInOut),
  GetPage(
      name: '/person/:id',
      page: () => const PersonPage(),
      transition: Transition.cupertino,
      curve: Curves.easeInOut),
  GetPage(
      name: '/publish',
      page: () => const PublishPage(),
      transition: Transition.downToUp,
      curve: Curves.bounceInOut),
  GetPage(
      name: '/setting',
      page: () => const SettingPage(),
      transition: Transition.cupertino,
      curve: Curves.easeInOut),
  GetPage(
      name: '/user/favorite',
      page: () => UserFavoritePage(),
      transition: Transition.cupertino,
      curve: Curves.easeInOut),
  GetPage(
      name: '/user/history',
      page: () => UserHistoryPage(),
      transition: Transition.cupertino,
      curve: Curves.easeInOut),
  GetPage(
      name: '/user/star',
      page: () => UserStarPage(),
      transition: Transition.cupertino,
      curve: Curves.easeInOut),
];

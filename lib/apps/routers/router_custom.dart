import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:music_sleeping/apps/routers/router_name.dart';
import 'package:music_sleeping/modules/home/bindings/home_binding.dart';
import 'package:music_sleeping/modules/home/pages/home_page.dart';

class RouterCustom {
  static final initial = RouterName.home;
  static final pages = [
    GetPage(
      name: RouterName.home,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
  ];
}

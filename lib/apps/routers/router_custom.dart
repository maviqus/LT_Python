import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:sleep_music/apps/routers/router_name.dart';
import 'package:sleep_music/modules/authencation/pages/sign_in_page.dart';
import 'package:sleep_music/modules/home/bindings/home_binding.dart';
import 'package:sleep_music/modules/profile/pages/profile_page.dart';
import 'package:sleep_music/modules/profile/bindings/profile_binding.dart';
import 'package:sleep_music/modules/slash/pages/slash_page.dart';
import 'package:sleep_music/modules/music/bindings/music_bindings.dart';
import 'package:flutter/material.dart';
import 'package:sleep_music/widgets/shared/root.dart';
import 'package:sleep_music/modules/music/pages/music_page.dart';

class RouterCustom {
  static final initial = RouterName.slash;
  static final pages = [
    GetPage(
      name: RouterName.root,
      page: () => HomeRootWidget(),
      binding: HomeBinding(),
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: RouterName.slash,
      page: () => SlashPage(),
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: RouterName.login,
      page: () => SignInPage(),
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: RouterName.alarm,
      page: () => Scaffold(body: Center(child: Text('Alarm Page'))),
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: RouterName.music,
      page: () => const MusicPage(),
      binding: MusicBinding(),
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: RouterName.profile,
      page: () => ProfilePage(),
      binding: ProfileBinding(),
      curve: Curves.easeInOut,
    ),
  ];
}

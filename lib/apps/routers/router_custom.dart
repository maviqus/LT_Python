import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:sleep_music/apps/routers/router_name.dart';
import 'package:sleep_music/modules/authencation/pages/sign_in_page.dart';
import 'package:sleep_music/modules/home/pages/home_page.dart';
import 'package:sleep_music/modules/slash/pages/slash_page.dart';

class RouterCustom {
  static final initial = RouterName.slash;
  static final pages = [
    GetPage(
      name: RouterName.home,
      page: () => HomePage(),
      transition: Transition.fade,
    ),
    GetPage(
      name: RouterName.slash,
      page: () => SlashPage(),
      transition: Transition.fade,
    ),
    GetPage(
      name: RouterName.login,
      page: () => SignInPage(),
      transition: Transition.fade,
    ),
  ];
}

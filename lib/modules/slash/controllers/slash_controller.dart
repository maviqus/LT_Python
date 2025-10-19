import 'package:get/get.dart';
import 'package:sleep_music/apps/routers/router_name.dart';
import 'package:sleep_music/modules/authencation/controller/authencation_controller.dart';

class SlashController extends GetxController {
  final AuthController authController = Get.find();
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(microseconds: 500), () {
      if (authController.isLoggedIn) {
        Get.offNamed(RouterName.root);
      } else {
        Get.offNamed(RouterName.login);
      }
    });
  }
}

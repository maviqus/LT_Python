import 'package:get/get.dart';
import 'package:sleep_music/modules/authencation/controller/authencation_controller.dart';
import 'package:sleep_music/controllers/theme_controller.dart';
import 'package:sleep_music/modules/slash/controllers/slash_controller.dart';
import 'package:sleep_music/modules/music/controllers/music_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.put(ThemeController());
    Get.put(SlashController());
    Get.put(MusicController());
  }
}

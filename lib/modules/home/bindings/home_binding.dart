import 'package:get/get.dart';
import 'package:sleep_music/modules/home/controllers/home_controller.dart';
import 'package:sleep_music/modules/music/controllers/music_controller.dart';
import 'package:sleep_music/controllers/root_controller.dart';
import 'package:sleep_music/controllers/music_player_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => MusicController());
    Get.lazyPut(() => MusicPlayerController());
    Get.lazyPut(() => RootController());
  }
}

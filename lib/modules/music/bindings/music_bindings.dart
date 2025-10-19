import 'package:get/get.dart';
import 'package:sleep_music/modules/music/controllers/music_controller.dart';

class MusicBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MusicController>(() => MusicController());
  }
}

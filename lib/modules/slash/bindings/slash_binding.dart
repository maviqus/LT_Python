import 'package:get/get.dart';
import 'package:sleep_music/modules/slash/controllers/slash_controller.dart';

class SlashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SlashController>(() => SlashController());
  }
}

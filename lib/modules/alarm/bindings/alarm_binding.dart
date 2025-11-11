import 'package:get/get.dart';
import 'package:sleep_music/modules/alarm/controllers/alarm_controller.dart';

class AlarmBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlarmController>(() => AlarmController());
  }
}

import 'package:get/get.dart';
import 'package:sleep_music/apps/routers/router_name.dart';

class SlashController extends GetxController {
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 1));

    isLoading.value = false;

    Get.offAllNamed(RouterName.root);
  }
}

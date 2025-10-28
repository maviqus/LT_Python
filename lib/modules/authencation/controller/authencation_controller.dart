import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sleep_music/apps/routers/router_name.dart';
import 'package:sleep_music/repositories/auth_repository.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  final GetStorage _storage = GetStorage();

  bool get isLoggedIn => _storage.read('isLoggedIn') ?? false;

  Future<void> signInWithGoogle() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      final user = await AuthRepository().loginWithGoogle();
      if (user != null) {
        _storage.write('isLoggedIn', true);
        Get.offAllNamed(RouterName.root);
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Đăng nhập thất bại: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInAnonymously() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      final user = await AuthRepository().loginAnonymously();
      if (user != null) {
        _storage.write('isLoggedIn', true);
        Get.offAllNamed(RouterName.root);
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Đăng nhập ẩn danh thất bại: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await AuthRepository().signOut();
    await _storage.write('isLoggedIn', false);
    Get.offAllNamed(RouterName.login);
  }
}

import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sleep_music/modules/authencation/controller/authencation_controller.dart';

class ProfileController extends GetxController {
  final AuthController authController = Get.find<AuthController>();

  Rx<User?> currentUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    currentUser.value = FirebaseAuth.instance.currentUser;

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      currentUser.value = user;
    });
  }

  String get userDisplayName => currentUser.value?.displayName ?? 'User';

  String get userEmail => currentUser.value?.email ?? '';

  String? get userPhotoUrl => currentUser.value?.photoURL;

  bool get hasPhoto => userPhotoUrl != null;

  Future<void> logout() async {
    await authController.signOut();
  }

  void navigateToSettings() {}

  void navigateToHelp() {}

  void navigateToAbout() {}
}

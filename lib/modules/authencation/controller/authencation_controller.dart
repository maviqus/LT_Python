import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '684753848387-gv6eh7kvuv6s21esc8397iqi25c6748i.apps.googleusercontent.com',
    scopes: ['email', 'profile'],
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var isLoading = false.obs;

  Future<void> signInWithGoogleAndFirebase() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      final GoogleSignInAccount? silentUser = await _googleSignIn
          .signInSilently();
      GoogleSignInAccount? googleUser = silentUser;
      if (googleUser == null) {
        googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          Get.snackbar('Thông báo', 'Đăng nhập bị hủy');
          return;
        }
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw Exception('Missing authentication tokens from Google');
      }
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      if (userCredential.user != null) {
        Get.snackbar(
          'Đăng nhập thành công!',
          'Chào mừng ${userCredential.user!.displayName ?? userCredential.user!.email}',
          duration: Duration(seconds: 3),
        );
        Get.offNamed('/home');
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Đăng nhập thất bại: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void signInWithEmail(String email, String password) async {
    isLoading.value = true;
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.offNamed('/home');
    } catch (e) {
      Get.snackbar('Lỗi', 'Đăng nhập thất bại: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

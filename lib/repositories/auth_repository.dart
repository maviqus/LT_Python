// login repository

import 'package:firebase_auth/firebase_auth.dart';
import 'package:sleep_music/repositories/api/firebase_backend.dart';

class AuthRepository {
  Future<User?> loginWithGoogle() async {
    try {
      return await FirebaseBackend().loginWithGoogle();
    } catch (e) {
      throw Exception('Error logging in with Google: $e');
    }
  }

  Future<void> signOut() async {
    await FirebaseBackend().signOut();
  }
}

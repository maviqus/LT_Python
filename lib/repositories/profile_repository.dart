import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sleep_music/repositories/api/firebase_backend.dart';
import 'package:sleep_music/utils/response.dart';

class ProfileRepository {
  static final ProfileRepository _instance = ProfileRepository._internal();
  factory ProfileRepository() => _instance;
  ProfileRepository._internal();

  final FirebaseBackend _firebaseBackend = FirebaseBackend();

  Future<ApiResponse<String>> changeAvatar(File imageFile) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return ApiResponse.error('User not authenticated');
      }

      final downloadUrl = await _firebaseBackend.uploadUserAvatar(
        imageFile,
        user.uid,
      );

      if (downloadUrl == null) {
        return ApiResponse.error('Failed to upload avatar image');
      }

      final updateSuccess = await _firebaseBackend.updateUserAvatarUrl(
        downloadUrl,
      );

      if (!updateSuccess) {
        return ApiResponse.error('Failed to update user profile');
      }

      return ApiResponse.success(downloadUrl);
    } catch (e) {
      return ApiResponse.error('Error changing avatar: ${e.toString()}');
    }
  }

  Future<ApiResponse<bool>> removeAvatar() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return ApiResponse.error('User not authenticated');
      }

      final deleteSuccess = await _firebaseBackend.deleteUserAvatar(user.uid);

      final updateSuccess = await _firebaseBackend.updateUserAvatarUrl('');

      if (!updateSuccess) {
        return ApiResponse.error('Failed to remove avatar from profile');
      }

      return ApiResponse.success(deleteSuccess);
    } catch (e) {
      return ApiResponse.error('Error removing avatar: ${e.toString()}');
    }
  }
}

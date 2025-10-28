import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sleep_music/modules/authencation/controller/authencation_controller.dart';
import 'package:sleep_music/repositories/profile_repository.dart';

class ProfileController extends GetxController {
  final AuthController authController = Get.find<AuthController>();
  final ProfileRepository _profileRepository = ProfileRepository();
  final ImagePicker _imagePicker = ImagePicker();

  Rx<User?> currentUser = Rx<User?>(null);
  RxBool isUpdatingAvatar = false.obs;
  RxString avatarUploadError = ''.obs;

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

  // Avatar methods

  /// Pick and update user avatar from gallery
  Future<void> changeAvatarFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        await _uploadAvatar(File(image.path));
      }
    } catch (e) {
      avatarUploadError.value = 'Error selecting image: ${e.toString()}';
    }
  }

  /// Pick and update user avatar from camera
  Future<void> changeAvatarFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        await _uploadAvatar(File(image.path));
      }
    } catch (e) {
      avatarUploadError.value = 'Error taking photo: ${e.toString()}';
    }
  }

  /// Upload avatar to Firebase Storage and update user profile
  Future<void> _uploadAvatar(File imageFile) async {
    try {
      isUpdatingAvatar.value = true;
      avatarUploadError.value = '';

      final response = await _profileRepository.changeAvatar(imageFile);

      if (response.isSuccess) {
        // Reload current user to get updated photo URL
        await FirebaseAuth.instance.currentUser?.reload();
        currentUser.value = FirebaseAuth.instance.currentUser;

        Get.snackbar(
          'Success',
          'Avatar updated successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        avatarUploadError.value =
            response.errorMessage ?? 'Failed to update avatar';
        Get.snackbar(
          'Error',
          avatarUploadError.value,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      avatarUploadError.value = 'Error uploading avatar: ${e.toString()}';
      Get.snackbar(
        'Error',
        avatarUploadError.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUpdatingAvatar.value = false;
    }
  }

  /// Remove user avatar
  Future<void> removeAvatar() async {
    try {
      isUpdatingAvatar.value = true;
      avatarUploadError.value = '';

      final response = await _profileRepository.removeAvatar();

      if (response.isSuccess) {
        // Reload current user to get updated photo URL
        await FirebaseAuth.instance.currentUser?.reload();
        currentUser.value = FirebaseAuth.instance.currentUser;

        Get.snackbar(
          'Success',
          'Avatar removed successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        avatarUploadError.value =
            response.errorMessage ?? 'Failed to remove avatar';
        Get.snackbar(
          'Error',
          avatarUploadError.value,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      avatarUploadError.value = 'Error removing avatar: ${e.toString()}';
      Get.snackbar(
        'Error',
        avatarUploadError.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUpdatingAvatar.value = false;
    }
  }

  /// Show avatar options bottom sheet
  void showAvatarOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Change Avatar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAvatarOption(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () {
                    Get.back();
                    changeAvatarFromCamera();
                  },
                ),
                _buildAvatarOption(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () {
                    Get.back();
                    changeAvatarFromGallery();
                  },
                ),
                if (hasPhoto)
                  _buildAvatarOption(
                    icon: Icons.delete,
                    label: 'Remove',
                    onTap: () {
                      Get.back();
                      removeAvatar();
                    },
                  ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 30, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }
}

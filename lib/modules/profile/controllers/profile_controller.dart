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

  // Cache avatar URL to avoid unnecessary reloads
  RxString cachedAvatarUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    currentUser.value = FirebaseAuth.instance.currentUser;

    // Initialize cached avatar URL
    cachedAvatarUrl.value = currentUser.value?.photoURL ?? '';

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      currentUser.value = user;
      // Update cached avatar URL when user changes
      cachedAvatarUrl.value = user?.photoURL ?? '';
    });
  }

  String get userDisplayName => currentUser.value?.displayName ?? 'User';

  String get userEmail => currentUser.value?.email ?? '';

  String? get userPhotoUrl =>
      cachedAvatarUrl.value.isNotEmpty ? cachedAvatarUrl.value : null;

  bool get hasPhoto => userPhotoUrl != null && userPhotoUrl!.isNotEmpty;

  Future<void> logout() async {
    await authController.signOut();
  }

  Future<void> updateDisplayName(String newName) async {
    if (newName.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Name cannot be empty',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final success = await _profileRepository.updateDisplayName(
        newName.trim(),
      );

      if (success.isSuccess) {
        await FirebaseAuth.instance.currentUser?.reload();
        currentUser.value = FirebaseAuth.instance.currentUser;

        Get.snackbar(
          'Success',
          'Name updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Error',
          success.errorMessage ?? 'Unable to update name',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error updating name: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void showEditNameDialog() {
    final TextEditingController nameController = TextEditingController();
    nameController.text = userDisplayName;

    Get.dialog(
      AlertDialog(
        title: const Text('Change Name'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Display Name',
            hintText: 'Enter new name',
          ),
          maxLength: 50,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              updateDisplayName(nameController.text);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  /// Force refresh user data from Firebase
  Future<void> refreshUserData() async {
    try {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      currentUser.value = user;

      final newAvatarUrl = user?.photoURL ?? '';
      if (cachedAvatarUrl.value != newAvatarUrl) {
        cachedAvatarUrl.value = newAvatarUrl;
      }
    } catch (e) {}
  }

  @override
  void onClose() {
    cachedAvatarUrl.value = '';
    super.onClose();
  }

  void navigateToSettings() {}

  void navigateToHelp() {}

  void navigateToAbout() {}

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
      avatarUploadError.value = 'Image selection error: ${e.toString()}';
      Get.snackbar(
        'Error',
        avatarUploadError.value,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> _uploadAvatar(File imageFile) async {
    try {
      isUpdatingAvatar.value = true;
      avatarUploadError.value = '';

      final response = await _profileRepository.changeAvatar(imageFile);

      if (response.isSuccess && response.data != null) {
        cachedAvatarUrl.value = response.data!;

        FirebaseAuth.instance.currentUser?.reload().then((_) {
          currentUser.value = FirebaseAuth.instance.currentUser;
        });

        Get.snackbar(
          'Success',
          'Avatar updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else {
        avatarUploadError.value =
            response.errorMessage ?? 'Avatar update error';
        Get.snackbar(
          'Error',
          avatarUploadError.value,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      avatarUploadError.value = 'Upload error: ${e.toString()}';
      Get.snackbar(
        'Error',
        avatarUploadError.value,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isUpdatingAvatar.value = false;
    }
  }

  Future<void> removeAvatar() async {
    try {
      isUpdatingAvatar.value = true;
      avatarUploadError.value = '';

      final response = await _profileRepository.removeAvatar();

      if (response.isSuccess) {
        cachedAvatarUrl.value = '';

        FirebaseAuth.instance.currentUser?.reload().then((_) {
          currentUser.value = FirebaseAuth.instance.currentUser;
        });

        Get.snackbar(
          'Success',
          'Avatar removed successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        avatarUploadError.value =
            response.errorMessage ?? 'Unable to remove avatar';
        Get.snackbar(
          'Error',
          avatarUploadError.value,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      avatarUploadError.value = 'Avatar removal error: ${e.toString()}';
      Get.snackbar(
        'Error',
        avatarUploadError.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUpdatingAvatar.value = false;
    }
  }

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

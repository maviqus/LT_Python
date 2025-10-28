import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleep_music/controllers/root_controller.dart';
import 'package:sleep_music/modules/profile/controllers/profile_controller.dart';
import 'package:sleep_music/widgets/profile/profile_widgets.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final RootController rootController = Get.find<RootController>();
    final ProfileController profileController = Get.find<ProfileController>();
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final extraBottom = 70 + 56 + bottomInset;

    return RefreshIndicator(
      onRefresh: profileController.refreshUserData,
      color: Colors.white,
      backgroundColor: Colors.blue,
      child: SingleChildScrollView(
        controller: rootController.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16, 24, 16, 24 + extraBottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ProfileHeader(),
            const SizedBox(height: 20),
            const UserInfoCard(),
            const SizedBox(height: 20),
            ProfileOptionTile(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () {},
            ),
            const SizedBox(height: 12),
            ProfileOptionTile(
              icon: Icons.help,
              title: 'Help & Support',
              onTap: () {},
            ),
            const SizedBox(height: 12),
            ProfileOptionTile(icon: Icons.info, title: 'About', onTap: () {}),
            const SizedBox(height: 20),
            const ProfileLogoutButton(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

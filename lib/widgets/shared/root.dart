import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'package:scroll_to_hide/scroll_to_hide.dart';
import 'package:sleep_music/controllers/root_controller.dart';
import 'package:sleep_music/widgets/shared/nav_item.dart';
import 'package:sleep_music/widgets/music/music_player.dart';

class HomeRootWidget extends StatelessWidget {
  const HomeRootWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final RootController rootController = Get.find<RootController>();
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Obx(
      () => Scaffold(
        extendBody: true,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            top: true,
            bottom: false,
            child: Column(
              children: [
                Expanded(
                  child:
                      rootController.pages[rootController.currentIndex.value],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: ScrollToHide(
          scrollController: rootController.scrollController,
          hideDirection: Axis.vertical,
          height: 70 + 56 + bottomPadding,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.2),
                  Colors.white.withValues(alpha: 0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: Border(
                top: BorderSide(color: Colors.white.withValues(alpha: 0.3), width: 1),
              ),
            ),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                      ),
                      child: const MusicPlayer(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 12,
                        right: 12,
                        top: 8,
                        bottom: 8 + bottomPadding,
                      ),
                      child: Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () => rootController.changePage(0),
                              child: NavItem(
                                icon: Icons.home,
                                label: 'Home',
                                selected:
                                    rootController.currentIndex.value == 0,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => rootController.changePage(1),
                              child: NavItem(
                                icon: Icons.sports_esports,
                                label: 'Alarm',
                                selected:
                                    rootController.currentIndex.value == 1,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => rootController.changePage(2),
                              child: NavItem(
                                icon: Icons.library_music,
                                label: 'Music',
                                selected:
                                    rootController.currentIndex.value == 2,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => rootController.changePage(3),
                              child: NavItem(
                                icon: Icons.person,
                                label: 'Profile',
                                selected:
                                    rootController.currentIndex.value == 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

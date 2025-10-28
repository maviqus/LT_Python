import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sleep_music/modules/home/pages/home_page.dart';
import 'package:sleep_music/modules/music/controllers/music_controller.dart';
import 'package:sleep_music/modules/profile/pages/profile_page.dart';
import 'package:sleep_music/modules/profile/controllers/profile_controller.dart';
import 'package:sleep_music/modules/music/pages/music_page.dart';
import 'package:sleep_music/modules/alarm/pages/alarm_page.dart';

class RootController extends GetxController {
  RxInt currentIndex = 0.obs;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    Get.put(ProfileController());
    scrollController.addListener(() {});
    loadData();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void loadData() {
    try {
      final MusicController musicController = Get.find<MusicController>();
      musicController.load();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading music data: $e');
      }
    }
  }

  List<Widget> pages = [
    HomePage(),
    const AlarmPage(),
    const MusicPage(),
    ProfilePage(),
  ];

  void changePage(int index) {
    currentIndex.value = index;
  }

  void onScroll(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
      if (kDebugMode) {
        print('Scrolled to the bottom');
      }
    }
  }
}

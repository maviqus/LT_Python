import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sleep_music/controllers/theme_controller.dart';
import 'package:sleep_music/modules/slash/controllers/slash_controller.dart';

class SlashPage extends GetView<SlashController> {
  const SlashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? const Color(0xFF1E1E1E)
          : const Color(0xFFF5F3CE),
      body: Center(
        child: Text(
          'Sleep Music',
          style: GoogleFonts.inter(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: themeController.isDarkMode.value
                ? Color(0xFFFFFFFF)
                : Color(0xff212121),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sleep_music/apps/routers/router_name.dart';
import 'package:sleep_music/controllers/theme_controller.dart';

class SlashPage extends StatefulWidget {
  const SlashPage({super.key});

  @override
  State<SlashPage> createState() => _SlashPageState();
}

class _SlashPageState extends State<SlashPage> {
  final ThemeController themeController = Get.find();
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      Get.offNamed(RouterName.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode.value
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

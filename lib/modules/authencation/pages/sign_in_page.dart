import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleep_music/modules/authencation/controller/authencation_controller.dart';
import 'package:sleep_music/controllers/theme_controller.dart';

class SignInPage extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final dark = themeController.isDarkMode.value;
      final bg = dark ? Color(0xFF1E1E1E) : Color(0xFFF5F3CE);
      return Scaffold(
        backgroundColor: bg,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: Icon(
                    dark ? Icons.wb_sunny_outlined : Icons.nightlight_round,
                    color: dark ? Colors.white : Colors.black,
                  ),
                  tooltip: 'Chuyển theme',
                  onPressed: () => themeController.toggleTheme(),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/logomusicsleep.png',
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 32),
                      Text(
                        'MUSIC SLEEPING',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: dark ? Colors.white : Colors.black,
                          letterSpacing: 2.0,
                        ),
                      ),
                      SizedBox(height: 48),
                      Obx(
                        () => SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: authController.isLoading.value
                                ? null
                                : authController.signInWithGoogleAndFirebase,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: dark
                                  ? Color(0xFF3A3A3A)
                                  : Color(0xFFFDB623),
                              foregroundColor: Colors.black87,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: authController.isLoading.value
                                ? SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.black87,
                                      ),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/logogg.png',
                                        height: 20,
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'Continue with Google',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleep_music/controllers/music_player_controller.dart';

class PlayButtonWidget extends StatelessWidget {
  final double? size;
  final Color? backgroundColor;
  final Color? iconColor;

  const PlayButtonWidget({
    super.key,
    this.size,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MusicPlayerController>();
    final buttonSize = size ?? 56;
    final iconSize = (buttonSize * 0.6).roundToDouble();

    return GestureDetector(
      onTap: () => controller.togglePlayPause(),
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          shape: BoxShape.circle,
        ),
        child: Obx(() {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: Icon(
              key: ValueKey(controller.isPlaying.value),
              controller.isPlaying.value
                  ? Icons.pause
                  : Icons.play_arrow_rounded,
              color: iconColor ?? Colors.black,
              size: iconSize,
            ),
          );
        }),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:sleep_music/widgets/shared/play_button_widget.dart';
import 'package:sleep_music/controllers/music_player_controller.dart';

class MusicControlsCard extends StatelessWidget {
  final VoidCallback? onShare;
  final VoidCallback? onDownload;
  final List<Color>? gradientColors;

  const MusicControlsCard({
    super.key,
    this.onShare,
    this.onDownload,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final MusicPlayerController musicController =
        Get.find<MusicPlayerController>();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.2),
            Colors.white.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Obx(
                () => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(
                      alpha: musicController.hasPrevious ? 0.1 : 0.05,
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(
                        alpha: musicController.hasPrevious ? 0.3 : 0.1,
                      ),
                      width: 1,
                    ),
                  ),
                  child: ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: IconButton(
                        icon: Icon(
                          Icons.skip_previous_rounded,
                          color: Colors.white.withValues(
                            alpha: musicController.hasPrevious ? 1.0 : 0.4,
                          ),
                          shadows: const [
                            Shadow(
                              blurRadius: 8.0,
                              color: Colors.black26,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        onPressed: musicController.hasPrevious
                            ? () => musicController.playPrevious()
                            : null,
                      ),
                    ),
                  ),
                ),
              ),

              const PlayButtonWidget(),

              Obx(
                () => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(
                      alpha: musicController.hasNext ? 0.1 : 0.05,
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(
                        alpha: musicController.hasNext ? 0.3 : 0.1,
                      ),
                      width: 1,
                    ),
                  ),
                  child: ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: IconButton(
                        icon: Icon(
                          Icons.skip_next_rounded,
                          color: Colors.white.withValues(
                            alpha: musicController.hasNext ? 1.0 : 0.4,
                          ),
                          shadows: const [
                            Shadow(
                              blurRadius: 8.0,
                              color: Colors.black26,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        onPressed: musicController.hasNext
                            ? () => musicController.playNext()
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

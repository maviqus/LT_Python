import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'package:sleep_music/controllers/music_player_controller.dart';

class MusicCardWidget extends StatelessWidget {
  final MusicPlayerController player;

  const MusicCardWidget({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentMusic = player.currentMusic.value;
      final hasMusic = currentMusic != null;

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withValues(alpha: 0.1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                  child: Icon(
                    Icons.music_note,
                    color: Colors.white.withValues(alpha: 0.7),
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasMusic ? currentMusic.title : 'No music playing',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        hasMusic
                            ? currentMusic.artist
                            : 'Start playing music to set timer',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  child: IconButton(
                    onPressed: hasMusic ? () => player.togglePlayPause() : null,
                    icon: Icon(
                      player.isPlaying.value ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleep_music/controllers/root_controller.dart';
import 'package:sleep_music/controllers/music_player_controller.dart';
import 'package:sleep_music/modules/music/controllers/music_controller.dart';
import 'package:sleep_music/modules/music/pages/music_detail_page.dart';
import 'package:sleep_music/modules/music/pages/music_category_page.dart';
import 'package:sleep_music/modules/music/widgets/music_empty_widget.dart';
import 'package:sleep_music/modules/music/widgets/music_error_widget.dart';
import 'package:sleep_music/modules/music/widgets/music_section_widget.dart';

class MusicPage extends StatelessWidget {
  const MusicPage({super.key});

  static const List<String> sampleImages = [
    'assets/images/sample_music.png',
    'assets/images/sample_music.png',
    'assets/images/sample_music.png',
    'assets/images/sample_music.png',
    'assets/images/sample_music.png',
    'assets/images/sample_music.png',
    'assets/images/sample_music.png',
    'assets/images/sample_music.png',
    'assets/images/sample_music.png',
  ];

  @override
  Widget build(BuildContext context) {
    final RootController rootController = Get.find<RootController>();
    final MusicController music = Get.find<MusicController>();
    final MusicPlayerController player = Get.find<MusicPlayerController>();

    final bottomInset = MediaQuery.of(context).padding.bottom;
    final extraBottom = 70 + 56 + bottomInset;

    return SingleChildScrollView(
      controller: rootController.scrollController,
      padding: EdgeInsets.fromLTRB(16, 24, 16, 24 + extraBottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Music',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.black26,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (music.isLoading.value && music.items.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    'Loading music...',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      shadows: [
                        Shadow(
                          blurRadius: 8.0,
                          color: Colors.black26,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            if (music.error.isNotEmpty) {
              return MusicErrorWidget(
                errorMessage: music.error.value,
                onRetry: () => music.load(),
              );
            }

            final Map<String, List<int>> byCategory = {};
            for (int i = 0; i < music.items.length; i++) {
              final key = music.items[i].category ?? 'Other';
              byCategory.putIfAbsent(key, () => []).add(i);
            }

            final sections = byCategory.entries.toList();
            if (sections.isEmpty) {
              return MusicEmptyWidget(
                subTextColor: Colors.white70,
                onRetry: () => music.load(),
              );
            }

            return Column(
              children: [
                for (int s = 0; s < sections.length; s++)
                  Container(
                    margin: EdgeInsets.only(bottom: 24),
                    child: MusicSectionWidget(
                      title: sections[s].key.isEmpty
                          ? 'Other'
                          : sections[s].key[0].toUpperCase() +
                                sections[s].key.substring(1),
                      images: sections[s].value
                          .map(
                            (i) =>
                                music.items[i].coverUrl ?? sampleImages.first,
                          )
                          .toList(),
                      musicNames: sections[s].value
                          .map((i) => music.items[i].name)
                          .toList(),
                      sectionCardColor: const Color(
                        0xFF2C2C2C,
                      ).withValues(alpha: 0.3),
                      textColor: Colors.white,
                      subTextColor: Colors.white70,
                      onTapTile: (i) {
                        final idx = sections[s].value[i];
                        final m = music.items[idx];
                        final musicList = music.items.toList();

                        player.playMusicFromPlaylist(musicList, idx);
                        Get.to(
                          () => MusicDetailPage(
                            imagePath: m.coverUrl ?? sampleImages.first,
                            title: m.title,
                            subtitle: m.artist,
                            music: m,
                          ),
                        );
                      },
                      onViewAll: () {
                        final categoryMusic = sections[s].value
                            .map((i) => music.items[i])
                            .toList();
                        Get.to(
                          () => MusicCategoryPage(
                            categoryName: sections[s].key.isEmpty
                                ? 'Other'
                                : sections[s].key[0].toUpperCase() +
                                      sections[s].key.substring(1),
                            categoryMusicList: categoryMusic,
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          }),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}

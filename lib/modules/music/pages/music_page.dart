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
              return _buildLoadingPlaceholders();
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

  Widget _buildLoadingPlaceholders() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Generate 3 category placeholders
        for (int categoryIndex = 0; categoryIndex < 3; categoryIndex++) ...[
          _buildCategoryPlaceholder(),
          const SizedBox(height: 24),
        ],
      ],
    );
  }

  Widget _buildCategoryPlaceholder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category title placeholder
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AnimatedOpacity(
              opacity: 0.4,
              duration: const Duration(milliseconds: 1000),
              child: Container(
                width: 120,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: 0.3,
              duration: const Duration(milliseconds: 1200),
              child: Container(
                width: 60,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Music items placeholder
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5, // Show 5 placeholder items
            itemBuilder: (context, index) {
              return Container(
                width: 110,
                margin: EdgeInsets.only(right: index == 4 ? 0 : 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image placeholder
                    AspectRatio(
                      aspectRatio: 1.0,
                      child: AnimatedOpacity(
                        opacity: 0.4 - (index * 0.05), // Varying opacity
                        duration: Duration(milliseconds: 800 + (index * 200)),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: AnimatedOpacity(
                            opacity: 0.2,
                            duration: Duration(
                              milliseconds: 1000 + (index * 100),
                            ),
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Title placeholder
                    AnimatedOpacity(
                      opacity: 0.3 - (index * 0.03),
                      duration: Duration(milliseconds: 900 + (index * 150)),
                      child: Container(
                        width: double.infinity,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

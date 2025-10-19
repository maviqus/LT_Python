import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui';
import 'package:scroll_to_hide/scroll_to_hide.dart';
import 'package:sleep_music/controllers/root_controller.dart';
import 'package:sleep_music/controllers/music_player_controller.dart';
import 'package:sleep_music/modules/music/pages/music_detail_page.dart';
import 'package:sleep_music/models/music.dart';
import 'package:sleep_music/widgets/shared/nav_item.dart';
import 'package:sleep_music/widgets/music/music_player.dart';

///srcoll more
///
class MusicCategoryPage extends StatelessWidget {
  final String categoryName;
  final List<Music> categoryMusicList;

  const MusicCategoryPage({
    super.key,
    required this.categoryName,
    required this.categoryMusicList,
  });

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
    final MusicPlayerController player = Get.find<MusicPlayerController>();
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black26,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                onPressed: () => Get.back(),
              ),
              title: Text(
                categoryName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black26,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              centerTitle: true,
            ),
            Expanded(
              child: SafeArea(
                top: false,
                bottom: false,
                child: categoryMusicList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.music_note,
                              size: 64,
                              color: Colors.white.withValues(alpha: 0.5),
                              shadows: const [
                                Shadow(
                                  blurRadius: 8.0,
                                  color: Colors.black26,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No music found in this category',
                              style: const TextStyle(
                                fontSize: 16,
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
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: rootController.scrollController,
                        padding: EdgeInsets.fromLTRB(
                          16,
                          16,
                          16,
                          16 + 70 + 56 + bottomPadding,
                        ),
                        itemCount: categoryMusicList.length,
                        itemBuilder: (context, index) {
                          final music = categoryMusicList[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withValues(alpha: 0.2),
                                  Colors.white.withValues(alpha: 0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 10,
                                  sigmaY: 10,
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      final musicIndex = categoryMusicList
                                          .indexWhere((m) => m.id == music.id);
                                      if (musicIndex >= 0) {
                                        player.playMusicFromPlaylist(
                                          categoryMusicList,
                                          musicIndex,
                                        );
                                      } else {
                                        player.playMusic(music);
                                      }
                                      Get.to(
                                        () => MusicDetailPage(
                                          imagePath:
                                              music.coverUrl ??
                                              sampleImages.first,
                                          title: music.title,
                                          subtitle: music.artist,
                                          music: music,
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: Container(
                                              width: 60,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                color: Colors.white.withValues(
                                                  alpha: 0.1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.2),
                                                  width: 1,
                                                ),
                                              ),
                                              child: _buildImageWidget(
                                                music.coverUrl ??
                                                    sampleImages.first,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  music.name,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                    shadows: [
                                                      Shadow(
                                                        blurRadius: 10.0,
                                                        color: Colors.black26,
                                                        offset: Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  music.artist,
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
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                if (music.durationSeconds !=
                                                    null)
                                                  const SizedBox(height: 2),
                                                if (music.durationSeconds !=
                                                    null)
                                                  Text(
                                                    _formatDuration(
                                                      music.durationSeconds!,
                                                    ),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white70
                                                          .withValues(
                                                            alpha: 0.7,
                                                          ),
                                                      shadows: const [
                                                        Shadow(
                                                          blurRadius: 8.0,
                                                          color: Colors.black26,
                                                          offset: Offset(0, 1),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white.withValues(
                                                alpha: 0.1,
                                              ),
                                              border: Border.all(
                                                color: Colors.white.withValues(
                                                  alpha: 0.3,
                                                ),
                                                width: 1,
                                              ),
                                            ),
                                            child: ClipOval(
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(
                                                  sigmaX: 5,
                                                  sigmaY: 5,
                                                ),
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.play_arrow,
                                                    color: Colors.white,
                                                    size: 24,
                                                    shadows: [
                                                      Shadow(
                                                        blurRadius: 8.0,
                                                        color: Colors.black26,
                                                        offset: Offset(0, 1),
                                                      ),
                                                    ],
                                                  ),
                                                  onPressed: () {
                                                    final musicIndex =
                                                        categoryMusicList
                                                            .indexWhere(
                                                              (m) =>
                                                                  m.id ==
                                                                  music.id,
                                                            );
                                                    if (musicIndex >= 0) {
                                                      player
                                                          .playMusicFromPlaylist(
                                                            categoryMusicList,
                                                            musicIndex,
                                                          );
                                                    } else {
                                                      player.playMusic(music);
                                                    }
                                                    Get.to(
                                                      () => MusicDetailPage(
                                                        imagePath:
                                                            music.coverUrl ??
                                                            sampleImages.first,
                                                        title: music.title,
                                                        subtitle: music.artist,
                                                        music: music,
                                                      ),
                                                    );
                                                  },
                                                ),
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
                        },
                      ),
              ),
            ),
          ],
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
              top: BorderSide(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
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
                              selected: rootController.currentIndex.value == 0,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => rootController.changePage(1),
                            child: NavItem(
                              icon: Icons.sports_esports,
                              label: 'Alarm',
                              selected: rootController.currentIndex.value == 1,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => rootController.changePage(2),
                            child: NavItem(
                              icon: Icons.library_music,
                              label: 'Music',
                              selected: rootController.currentIndex.value == 2,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => rootController.changePage(3),
                            child: NavItem(
                              icon: Icons.person,
                              label: 'Profile',
                              selected: rootController.currentIndex.value == 3,
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
    );
  }

  Widget _buildImageWidget(String imagePath) {
    if (imagePath.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.music_note,
          color: Colors.white,
          size: 24,
          shadows: [
            Shadow(
              blurRadius: 8.0,
              color: Colors.black26,
              offset: Offset(0, 1),
            ),
          ],
        ),
      );
    }

    if (imagePath.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        progressIndicatorBuilder: (context, child, loadingProgress) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'Loading...',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
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
        },
        errorWidget: (context, error, stackTrace) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.music_note,
              color: Colors.white,
              size: 24,
              shadows: [
                Shadow(
                  blurRadius: 8.0,
                  color: Colors.black26,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          );
        },
      );
    } else {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.music_note,
              color: Colors.white,
              size: 24,
              shadows: [
                Shadow(
                  blurRadius: 8.0,
                  color: Colors.black26,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

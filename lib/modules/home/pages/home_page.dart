// home page

import 'package:flutter/material.dart';
import 'package:sleep_music/widgets/shared/rounded_button.dart';
import '../../../widgets/shared/music_scroll.dart';
import '../../../widgets/shared/podcast_scroll.dart';
import '../../../widgets/shared/nav_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF232323) : const Color(0xFFF5F3CE);
    final cardColor = isDark
        ? const Color(0xFF2C2C2C)
        : const Color(0xFFE7E2B6);
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.black87;
    final buttonColor = isDark
        ? const Color(0xFF3A3A3A)
        : const Color(0xFFE7E2B6);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/sample_day.png',
                        width: 110,
                        height: 110,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Text(
                                  'HOW WAS YOUR DAY ?',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: textColor,
                                    letterSpacing: 1.2,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.18),
                                        offset: const Offset(0, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Frame',
                            style: TextStyle(
                              fontSize: 16,
                              color: subTextColor.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'quality sleep for a quality life\nquality sleep for a quality life\nquality sleep for a quality life\nquality sleep for a quality life\nquality sleep for a quality life\nquality sleep for a quality life\nquality sleep for a quality life',
                            style: TextStyle(fontSize: 15, color: subTextColor),
                            maxLines: 7,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: RoundedButton(
                        text: 'Start sleep',
                        onPressed: () {},
                        backgroundColor: buttonColor,
                        foregroundColor: textColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RoundedButton(
                        text: 'Set alarm',
                        onPressed: () {},
                        backgroundColor: buttonColor,
                        foregroundColor: textColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 16,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Image.asset(
                                'assets/images/moonsleep.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                '9:00 PM',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 16,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '9:00 AM',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Image.asset(
                              'assets/images/iconedit.png',
                              width: 20,
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Music for you
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Music for you',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'View all',
                        style: TextStyle(color: subTextColor),
                      ),
                    ),
                  ],
                ),
              ),
              MusicScroll(
                imagePaths: const [
                  'assets/images/sample_music.png',
                  'assets/images/sample_music.png',
                  'assets/images/sample_music.png',
                ],
              ),
              // Podcast
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                child: Text(
                  'Podcast',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: subTextColor,
                  ),
                ),
              ),
              PodcastScroll(
                imagePaths: const [
                  'assets/images/sample_podcast.png',
                  'assets/images/sample_podcast.png',
                ],
              ),
              const SizedBox(height: 16),
              // Bottom navigation bar (không bo tròn)
              Container(
                color: cardColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    NavItem(icon: Icons.home, label: 'Home', selected: true),
                    NavItem(icon: Icons.sports_esports, label: 'Alarm'),
                    NavItem(icon: Icons.library_music, label: 'Music'),
                    NavItem(icon: Icons.search, label: 'Profile'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

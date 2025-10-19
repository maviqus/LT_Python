import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MusicSectionWidget extends StatelessWidget {
  final String title;
  final List<String> images;
  final List<String> musicNames;
  final Color sectionCardColor;
  final Color textColor;
  final Color subTextColor;
  final void Function(int index) onTapTile;
  final VoidCallback? onViewAll;

  const MusicSectionWidget({
    super.key,
    required this.title,
    required this.images,
    required this.musicNames,
    required this.sectionCardColor,
    required this.textColor,
    required this.subTextColor,
    required this.onTapTile,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: textColor,
              ),
            ),
            TextButton(
              onPressed: onViewAll,
              child: Text('View all', style: TextStyle(color: subTextColor)),
            ),
          ],
        ),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            itemBuilder: (context, i) {
              return Container(
                width: 110,
                margin: EdgeInsets.only(right: i == images.length - 1 ? 0 : 12),
                child: GestureDetector(
                  onTap: () => onTapTile(i),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AspectRatio(
                        aspectRatio: 1.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            color: sectionCardColor,
                            child: _buildImageWidget(images[i]),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        i < musicNames.length ? musicNames[i] : title,
                        style: TextStyle(fontSize: 12, color: subTextColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  //skeleton for image loading
  Widget _buildImageWidget(String imagePath) {
    if (imagePath.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        progressIndicatorBuilder: (context, child, loadingProgress) {
          return Container(
            color: Colors.grey.shade200,
            child: Center(
              child: AnimatedOpacity(
                opacity: 0.5,
                duration: const Duration(milliseconds: 300),
                child: Text(
                  'Loading...',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ),
            ),
          );
        },
        errorWidget: (context, error, stackTrace) {
          return Container(
            color: Colors.grey.shade300,
            child: Icon(
              Icons.music_note,
              color: Colors.grey.shade600,
              size: 32,
            ),
          );
        },
      );
    } else {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey.shade300,
            child: Icon(
              Icons.music_note,
              color: Colors.grey.shade600,
              size: 32,
            ),
          );
        },
      );
    }
  }
}

import 'package:flutter/material.dart';

class PodcastScroll extends StatelessWidget {
  final List<String> imagePaths;
  final double itemWidth;
  final double itemHeight;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const PodcastScroll({
    super.key,
    required this.imagePaths,
    this.itemWidth = 80,
    this.itemHeight = 60,
    this.borderRadius = 12,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: itemHeight,
      child: ListView.separated(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: imagePaths.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) => ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Image.asset(
            imagePaths[i],
            width: itemWidth,
            height: itemHeight,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

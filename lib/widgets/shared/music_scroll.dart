import 'package:flutter/material.dart';

class MusicScroll extends StatelessWidget {
  final List<String> imagePaths;
  final double itemWidth;
  final double itemHeight;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const MusicScroll({
    super.key,
    required this.imagePaths,
    this.itemWidth = 90,
    this.itemHeight = 90,
    this.borderRadius = 16,
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
        separatorBuilder: (_, __) => const SizedBox(width: 16),
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

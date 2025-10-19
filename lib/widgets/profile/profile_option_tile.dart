import 'package:flutter/material.dart';
import 'dart:ui';

class ProfileOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ProfileOptionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.2),
            Colors.white.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: ListTile(
            leading: Icon(
              icon,
              color: Colors.white,
              shadows: const [
                Shadow(
                  blurRadius: 8.0,
                  color: Colors.black26,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            title: Text(
              title,
              style: const TextStyle(
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
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.white70,
              size: 16,
              shadows: const [
                Shadow(
                  blurRadius: 8.0,
                  color: Colors.black26,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}

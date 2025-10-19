import 'package:flutter/material.dart';

class MusicEmptyWidget extends StatelessWidget {
  final Color subTextColor;
  final VoidCallback onRetry;

  const MusicEmptyWidget({
    super.key,
    required this.subTextColor,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        children: [
          Text('No music found', style: TextStyle(color: subTextColor)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry Loading'),
          ),
        ],
      ),
    );
  }
}

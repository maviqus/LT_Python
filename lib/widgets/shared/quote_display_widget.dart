import 'package:flutter/material.dart';
import 'package:sleep_music/models/quote_model.dart';

class QuoteDisplayWidget extends StatefulWidget {
  final Quote quote;
  final Color textColor;

  const QuoteDisplayWidget({
    super.key,
    required this.quote,
    required this.textColor,
  });

  @override
  State<QuoteDisplayWidget> createState() => _QuoteDisplayWidgetState();
}

class _QuoteDisplayWidgetState extends State<QuoteDisplayWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    const int maxLength = 120;
    final fullText = '${widget.quote.text}\n\n- ${widget.quote.author}';
    final shouldTruncate = fullText.length > maxLength;
    final truncatedText = shouldTruncate
        ? '${fullText.substring(0, maxLength)}...'
        : fullText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedCrossFade(
          firstChild: Text(
            truncatedText,
            style: TextStyle(
              fontSize: 14,
              color: widget.textColor,
              height: 1.3,
            ),
            maxLines: null,
            overflow: TextOverflow.visible,
          ),
          secondChild: Text(
            fullText,
            style: TextStyle(
              fontSize: 14,
              color: widget.textColor,
              height: 1.3,
            ),
            maxLines: null,
            overflow: TextOverflow.visible,
          ),
          crossFadeState: _isExpanded || !shouldTruncate
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
        if (shouldTruncate) ...[
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Text(
              _isExpanded ? 'Read less' : 'Read more',
              style: TextStyle(
                fontSize: 12,
                color: widget.textColor.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

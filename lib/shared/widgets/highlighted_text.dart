import 'package:flutter/material.dart';

import '../extensions/context_x.dart';

/// Text with the given `[start, end)` ranges highlighted.
class HighlightedText extends StatelessWidget {
  const HighlightedText({super.key, required this.text, required this.ranges, required this.style, this.maxLines});

  final String text;
  final List<(int, int)> ranges;
  final TextStyle style;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final mark = TextStyle(
      backgroundColor: context.brand.highlight,
      color: context.colors.primary,
      fontWeight: FontWeight.w700,
    );
    final spans = <TextSpan>[];
    var cursor = 0;
    for (final (start, end) in ranges) {
      if (start < cursor || end > text.length) continue;
      if (start > cursor) spans.add(TextSpan(text: text.substring(cursor, start)));
      spans.add(TextSpan(text: text.substring(start, end), style: mark));
      cursor = end;
    }
    if (cursor < text.length) spans.add(TextSpan(text: text.substring(cursor)));
    return Text.rich(
      TextSpan(style: style, children: spans),
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
    );
  }
}

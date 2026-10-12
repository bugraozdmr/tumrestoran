import 'package:flutter/material.dart';

double getTextHeight({
  required String text,
  required double maxWidth,
  int maxLines = 4,
}) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(fontFamily: 'Rubik'),
    ),
    maxLines: maxLines,
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: maxWidth);

  return textPainter.size.height;
}

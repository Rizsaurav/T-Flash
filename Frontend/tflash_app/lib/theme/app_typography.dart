import 'package:flutter/material.dart';

class AppTypography {
  // Large Title (used for main headers)
  static const TextStyle largeTitle = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.37,
    height: 1.2,
  );

  // Title 1 (section headers)
  static const TextStyle title1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.36,
    height: 1.3,
  );

  // Title 2 (smaller headers)
  static const TextStyle title2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.35,
    height: 1.3,
  );

  // Title 3 (card titles)
  static const TextStyle title3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.38,
    height: 1.25,
  );

  // Headline (emphasized text)
  static const TextStyle headline = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.41,
    height: 1.3,
  );

  // Body (regular text)
  static const TextStyle body = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.41,
    height: 1.4,
  );

  // Callout (secondary info)
  static const TextStyle callout = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.32,
    height: 1.35,
  );

  // Subhead (less important text)
  static const TextStyle subhead = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.24,
    height: 1.35,
  );

  // Footnote (captions, timestamps)
  static const TextStyle footnote = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.08,
    height: 1.3,
  );

  // Caption 1 (smallest text)
  static const TextStyle caption1 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.3,
  );

  // Caption 2 (even smaller)
  static const TextStyle caption2 = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.06,
    height: 1.3,
  );
}

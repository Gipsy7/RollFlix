import 'package:flutter/material.dart';

extension ColorOpacityExtension on Color {
  Color withOpacitySafe(double opacity) {
    final clamped = opacity.clamp(0.0, 1.0);
    final alpha = (clamped * 255).round();
    return withAlpha(alpha);
  }
}

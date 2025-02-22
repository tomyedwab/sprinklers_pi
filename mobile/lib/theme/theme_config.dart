import 'package:flutter/material.dart';
import 'app_theme.dart';

class ThemeConfig {
  static ThemeData lightTheme() {
    final baseTheme = ThemeData.light(useMaterial3: true);
    return baseTheme.copyWith(
      extensions: [
        AppTheme.light(baseTheme),
      ],
    );
  }

  static ThemeData darkTheme() {
    final baseTheme = ThemeData.dark(useMaterial3: true);
    return baseTheme.copyWith(
      extensions: [
        AppTheme.dark(baseTheme),
      ],
    );
  }
} 
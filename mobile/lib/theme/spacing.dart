import 'package:flutter/material.dart';

/// Design system spacing values
class Spacing {
  // Base spacing unit (4.0)
  static const double unit = 4.0;

  // Spacing scale
  static const double xs = unit * 2;    // 8.0
  static const double sm = unit * 3;    // 12.0
  static const double md = unit * 4;    // 16.0
  static const double lg = unit * 6;    // 24.0
  static const double xl = unit * 8;    // 32.0
  static const double xxl = unit * 12;  // 48.0

  // Layout specific spacing
  static const double cardPadding = md;        // 16.0
  static const double cardSpacing = md;        // 16.0
  static const double sectionSpacing = lg;     // 24.0
  static const double screenPadding = md;      // 16.0
  static const double contentSpacing = md;     // 16.0

  // Responsive breakpoints
  static const double wideScreenBreakpoint = 600.0;

  // Screen-specific spacing
  static EdgeInsets get screenPaddingAll => const EdgeInsets.all(screenPadding);
  
  static EdgeInsets get cardPaddingAll => const EdgeInsets.all(cardPadding);
  
  static EdgeInsets get contentSpacingVertical => 
      const EdgeInsets.symmetric(vertical: contentSpacing);
      
  static EdgeInsets get contentSpacingHorizontal => 
      const EdgeInsets.symmetric(horizontal: contentSpacing);
} 
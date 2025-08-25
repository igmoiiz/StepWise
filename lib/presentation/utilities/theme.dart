import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//  Light Mode
ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  fontFamily: GoogleFonts.outfit().fontFamily,
  colorScheme: ColorScheme.light(),
);

//  Dark Mode
ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  fontFamily: GoogleFonts.urbanist().fontFamily,
  colorScheme: ColorScheme.dark(
    primary: const Color(0xFF6366F1), // Primary Color -> Main Buttons etc
    surface: const Color(0xFF0F0F0F), //  Background Color
    onSurface: const Color(0xFFE5E5E5), //  Main Text Color - High contrast
    surfaceContainerHighest: const Color(0xFF1F1F1F), //  Panels and cards accent Color
    onSurfaceVariant: const Color(0xFFB0B0B0), //  Subtext and Labels - Better contrast
    onPrimary: const Color(0xFFFFFFFF), //  Button text
    error: const Color(0xFFEF4444), //  Error Color
    secondary: const Color(0xFF10B981), //  Success Color
    primaryContainer: const Color(0xFF4338CA),
    secondaryContainer: const Color(0xFF059669),
    errorContainer: const Color(0xFF7F1D1D),
    onErrorContainer: const Color(0xFFFECACA),
  ),
);

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
    primary: const Color(0xFF1F3A93), // Primary Color -> Main Buttons etc
    surface: const Color(0xFF121212), //  Background Color
    onSurface: const Color(0xFF1E1E1E), //  Panels and cards accent Color
    onPrimary: const Color(0xFFFFFFFF), //  Main Text Color
    onTertiary: const Color(0xFFBDC3C7), //  Subtext and Labels
    error: const Color(0xFFE74C3C), //  Error Color
    secondary: const Color(0xFF27AE60), //  Success Color
  ),
);

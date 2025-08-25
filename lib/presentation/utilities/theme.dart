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
  colorScheme: ColorScheme.dark(),
);

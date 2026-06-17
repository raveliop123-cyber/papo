import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // African-Inspired Palette
  // Light Mode: Warm Earth, Ochre, and Savanna Green
  static const Color terracotta = Color(0xFFE2725B); // Earth
  static const Color ochre = Color(0xFFCC7722); // Sun/Gold
  static const Color savannaGreen = Color(0xFF8A9A5B); // Nature
  static const Color lightSand = Color(0xFFFDF5E6); // Background
  static const Color deepCoal = Color(0xFF2C2C2C); // Text

  // Dark Mode: Deep Turquoise, Midnight Blue, and Bronze
  static const Color midnightBlue = Color(0xFF1A237E);
  static const Color deepTurquoise = Color(0xFF006064);
  static const Color bronze = Color(0xFFCD7F32);
  static const Color darkAbyss = Color(0xFF0F0F0F);

  // Gradients
  static const LinearGradient africanSunset = LinearGradient(
    colors: [Color(0xFFE2725B), Color(0xFFCC7722)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient savannaNight = LinearGradient(
    colors: [Color(0xFF1A237E), Color(0xFF006064)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: terracotta,
        secondary: ochre,
        tertiary: savannaGreen,
        background: lightSand,
        surface: Colors.white,
        onBackground: deepCoal,
        onSurface: deepCoal,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          color: deepCoal,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: terracotta,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: bronze,
        secondary: deepTurquoise,
        tertiary: midnightBlue,
        background: darkAbyss,
        surface: const Color(0xFF1E1E1E),
        onBackground: Colors.white,
        onSurface: Colors.white,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 4,
        color: const Color(0xFF252525),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: bronze,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}

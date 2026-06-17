import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color terracotta = Color(0xFFA44A2A);
  static const Color sahelGold = Color(0xFFD89216);
  static const Color baobabGreen = Color(0xFF2F6B4F);
  static const Color sand = Color(0xFFFFF8ED);
  static const Color ivory = Color(0xFFFFFFFF);
  static const Color warmEbony = Color(0xFF241A14);

  static const Color night = Color(0xFF080A12);
  static const Color charcoalBlue = Color(0xFF121827);
  static const Color indigoTextile = Color(0xFF4B5BD7);
  static const Color deepTurquoise = Color(0xFF1F8A70);
  static const Color softGold = Color(0xFFD9A441);
  static const Color nightIvory = Color(0xFFF6EAD2);

  static const LinearGradient africanSunset = LinearGradient(
    colors: [terracotta, sahelGold, baobabGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.05, 0.55, 1],
  );

  static const LinearGradient savannaNight = LinearGradient(
    colors: [night, indigoTextile, deepTurquoise],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0, 0.55, 1],
  );

  static const LinearGradient kenteAccent = LinearGradient(
    colors: [sahelGold, terracotta, Color(0xFF111111), baobabGreen],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: terracotta,
        secondary: sahelGold,
        tertiary: baobabGreen,
        surface: ivory,
        onPrimary: Colors.white,
        onSecondary: warmEbony,
        onTertiary: Colors.white,
        onSurface: warmEbony,
        error: Color(0xFFB3261E),
      ),
      scaffoldBackgroundColor: sand,
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: warmEbony,
        displayColor: warmEbony,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          color: warmEbony,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(color: warmEbony),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        color: ivory,
        shadowColor: terracotta.withOpacity(0.14),
        surfaceTintColor: sahelGold.withOpacity(0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: const EdgeInsets.symmetric(vertical: 8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ivory,
        prefixIconColor: terracotta,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: terracotta, width: 1.4),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: terracotta.withOpacity(0.18)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: terracotta,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w700),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: ivory,
        indicatorColor: sahelGold.withOpacity(0.2),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: softGold,
        secondary: deepTurquoise,
        tertiary: indigoTextile,
        surface: charcoalBlue,
        onPrimary: night,
        onSecondary: nightIvory,
        onTertiary: nightIvory,
        onSurface: nightIvory,
        error: Color(0xFFFFB4AB),
      ),
      scaffoldBackgroundColor: night,
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: nightIvory,
        displayColor: nightIvory,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          color: nightIvory,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(color: nightIvory),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        color: charcoalBlue,
        shadowColor: Colors.black.withOpacity(0.32),
        surfaceTintColor: deepTurquoise.withOpacity(0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: const EdgeInsets.symmetric(vertical: 8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: charcoalBlue,
        prefixIconColor: softGold,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: softGold, width: 1.4),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: softGold.withOpacity(0.2)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: softGold,
          foregroundColor: night,
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w700),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: charcoalBlue,
        indicatorColor: deepTurquoise.withOpacity(0.28),
      ),
    );
  }
}

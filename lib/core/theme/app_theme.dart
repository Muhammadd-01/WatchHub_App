import 'package:flutter/material.dart';

class AppTheme {
  // Color Palette
  static const Color primaryColor = Color(0xFF101820); // Near-black
  static const Color accentColor = Color(0xFFC59D5F); // Warm gold
  static const Color secondaryColor = Color(0xFFF7F7F7); // Light gray
  static const Color successColor = Color(0xFF28A745);
  static const Color errorColor = Color(0xFFE63946);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color textPrimary = Color(0xFF101820);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textLight = Color(0xFFF7F7F7);

  // Gradients
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF101820),
      Color(0xFF2B2B2B),
      Color(0xFFC59D5F),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x05FFFFFF),
      Color(0x05000000),
    ],
  );

  // Typography
  static const String headlineFont = 'Poppins';
  static const String bodyFont = 'Roboto';

  // Text Styles
  static const TextStyle h1 = TextStyle(
    fontFamily: headlineFont,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: headlineFont,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: headlineFont,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: bodyFont,
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: secondaryColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      error: errorColor,
      surface: surfaceLight,
      onPrimary: textLight,
      onSecondary: textPrimary,
      onSurface: textPrimary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceLight,
      foregroundColor: textPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: headlineFont,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
    ),
    cardTheme: CardThemeData(
      color: surfaceLight,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: textLight,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          fontFamily: bodyFont,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: accentColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: errorColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    textTheme: const TextTheme(
      displayLarge: h1,
      displayMedium: h2,
      displaySmall: h3,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: caption,
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: accentColor,
    scaffoldBackgroundColor: const Color(0xFF121212),
    colorScheme: const ColorScheme.dark(
      primary: accentColor,
      secondary: accentColor,
      error: errorColor,
      surface: surfaceDark,
      onPrimary: textPrimary,
      onSecondary: textLight,
      onSurface: textLight,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceDark,
      foregroundColor: textLight,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: headlineFont,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textLight,
      ),
    ),
    cardTheme: CardThemeData(
      color: surfaceDark,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        foregroundColor: textPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: accentColor,
        side: const BorderSide(color: accentColor, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF333333)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF333333)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: accentColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: errorColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: headlineFont,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textLight,
      ),
      displayMedium: TextStyle(
        fontFamily: headlineFont,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textLight,
      ),
      displaySmall: TextStyle(
        fontFamily: headlineFont,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textLight,
      ),
      bodyLarge: TextStyle(
        fontFamily: bodyFont,
        fontSize: 16,
        color: textLight,
      ),
      bodyMedium: TextStyle(
        fontFamily: bodyFont,
        fontSize: 14,
        color: textLight,
      ),
      bodySmall: TextStyle(
        fontFamily: bodyFont,
        fontSize: 12,
        color: Color(0xFFB0B0B0),
      ),
    ),
  );
}

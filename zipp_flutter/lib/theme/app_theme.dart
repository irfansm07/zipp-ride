import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color background = Color(0xFFEAF2F8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFF9BBCD0);
  static const Color teal = Color(0xFF2872A1); // Main blue
  static const Color amber = Color(0xFFf59e0b);
  static const Color pink = Color(0xFFff4d6d);
  static const Color blue = Color(0xFF1D6FA4); // Secondary blue
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF4A6B80); // Secondary text
  static const Color darkGrey = Color(0xFF0D2137); // Primary text
  static const Color success = Color(0xFF2872A1);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [teal, blue],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF7FAFD)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  static TextStyle heading1 = GoogleFonts.outfit(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.darkGrey,
  );

  static TextStyle heading2 = GoogleFonts.outfit(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.darkGrey,
  );

  static TextStyle heading3 = GoogleFonts.outfit(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.darkGrey,
  );

  static TextStyle body = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.darkGrey,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.grey,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.darkGrey,
  );

  static TextStyle button = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  static TextStyle caption = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.grey,
  );

  static BoxDecoration cardDecoration = BoxDecoration(
    color: AppColors.card,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AppColors.cardBorder, width: 1),
  );

  static BoxDecoration glowCardDecoration = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AppColors.teal.withValues(alpha: 0.3), width: 1.5),
    boxShadow: [
      BoxShadow(
        color: AppColors.teal.withValues(alpha: 0.1),
        blurRadius: 15,
        spreadRadius: 2,
      ),
    ],
  );

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.light(
          primary: AppColors.teal,
          secondary: AppColors.amber,
          surface: AppColors.surface,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          titleTextStyle: heading2,
          iconTheme: const IconThemeData(color: AppColors.darkGrey),
        ),
      );
}

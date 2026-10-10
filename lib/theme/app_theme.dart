import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  static const wall = Color(0xFFEDEEF0);
  static const ink = Color(0xFF1E2024);
  static const muted = Color(0xFF6B6F76);
  static const accent = Color(0xFF4E6476);
}

class AppText {
  AppText._();

  static TextStyle get wordmark => GoogleFonts.cormorantGaramond(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.italic,
        height: 1,
        color: AppColors.ink,
      );

  static TextStyle get date => GoogleFonts.workSans(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.muted,
      );

  static TextStyle get title => GoogleFonts.cormorantGaramond(
        fontSize: 40,
        fontWeight: FontWeight.w500,
        height: 1.05,
        letterSpacing: -0.5,
        color: AppColors.ink,
      );

  static TextStyle get artist => GoogleFonts.workSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      );

  static TextStyle get detail => GoogleFonts.workSans(
        fontSize: 14,
        height: 1.4,
        color: AppColors.muted,
      );
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accent,
        surface: AppColors.wall,
      ),
      scaffoldBackgroundColor: AppColors.wall,
      textTheme: GoogleFonts.workSansTextTheme(),
      useMaterial3: true,
    );
  }
}
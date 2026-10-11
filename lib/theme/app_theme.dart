import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:gallerist/theme/art_palette.dart';


class AppTheme {
  AppTheme._();

  static const fallbackSeed = Color(0xFF5B6B7A);

  static ThemeData build(Color seed) {
    final palette = ArtPalette.fromSeed(seed);
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: palette.accent,
        surface: palette.wall,
      ),
      scaffoldBackgroundColor: palette.wall,
      textTheme: GoogleFonts.workSansTextTheme().apply(
        bodyColor: palette.ink,
        displayColor: palette.ink,
      ),
      extensions: [palette],
      useMaterial3: true,
    );
  }
}

class AppText {
  AppText._();

  static TextStyle wordmark(ArtPalette p) => GoogleFonts.cormorantGaramond(
    fontSize: 26,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.italic,
    height: 1,
    color: p.ink,
  );

  static TextStyle date(ArtPalette p) => GoogleFonts.workSans(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: p.muted,
  );

  static TextStyle title(ArtPalette p) => GoogleFonts.cormorantGaramond(
    fontSize: 40,
    fontWeight: FontWeight.w500,
    height: 1.05,
    letterSpacing: -0.5,
    color: p.ink,
  );

  static TextStyle artist(ArtPalette p) => GoogleFonts.workSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: p.ink,
  );

  static TextStyle detail(ArtPalette p) =>
      GoogleFonts.workSans(fontSize: 14, height: 1.4, color: p.muted);

   static TextStyle sectionTitle(ArtPalette p) => GoogleFonts.cormorantGaramond(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.15,
        color: p.ink,
      );

  static TextStyle labelKey(ArtPalette p) => GoogleFonts.workSans(
        fontSize: 13,
        height: 1.45,
        color: p.muted,
      );

  static TextStyle labelValue(ArtPalette p) => GoogleFonts.workSans(
        fontSize: 14,
        height: 1.45,
        color: p.ink,
      );

  static TextStyle body(ArtPalette p) => GoogleFonts.workSans(
        fontSize: 15.5,
        height: 1.65,
        color: p.ink.withValues(alpha: 0.88),
      );

  static TextStyle caption(ArtPalette p) => GoogleFonts.workSans(
        fontSize: 12,
        height: 1.5,
        color: p.muted,
      );
}

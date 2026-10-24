import 'dart:math' as math;

import 'package:flutter/material.dart';

class ArtPalette extends ThemeExtension<ArtPalette> {
  const ArtPalette({
    required this.wall,
    required this.ink,
    required this.muted,
    required this.accent,
    required this.glow,
  });

  final Color wall;
  final Color ink;
  final Color muted;
  final Color accent;
  final Color glow;

  factory ArtPalette.fromSeed(Color seed, Brightness brightness) {
    final source = HSLColor.fromColor(seed);
    final hue = source.hue;
    final sat = source.saturation;
    final dark = brightness == Brightness.dark;

    HSLColor tone(double saturation, double lightness) => HSLColor.fromAHSL(
      1.0,
      hue,
      saturation.clamp(0.0, 1.0),
      lightness.clamp(0.0, 1.0),
    );

    final wall = dark
        ? tone(math.min(sat * 0.4, 0.20), 0.10).toColor()
        : tone(math.min(sat * 0.4, 0.22), 0.93).toColor();

    return ArtPalette(
      wall: wall,
      ink: dark
          ? tone(math.min(sat, 0.25), 0.92).toColor()
          : tone(math.min(sat, 0.35), 0.13).toColor(),
      muted: _readableOn(
        wall,
        dark
            ? tone(math.min(sat, 0.15), 0.66)
            : tone(math.min(sat, 0.20), 0.40),
      ),
      accent: _readableOn(
        wall,
        dark
            ? tone(sat.clamp(0.35, 0.75), 0.72)
            : tone(sat.clamp(0.35, 0.75), 0.40),
      ),
      glow: dark
          ? tone(sat.clamp(0.30, 0.80), 0.30).toColor()
          : tone(sat.clamp(0.30, 0.80), 0.50).toColor(),
    );
  }

  static Color _readableOn(Color background, HSLColor color) {
    final darker = background.computeLuminance() > 0.5;
    var current = color;

    while (contrast(current.toColor(), background) < 4.5) {
      final next = darker ? current.lightness - 0.02 : current.lightness + 0.02;
      if (next <= 0 || next >= 1) break;
      current = current.withLightness(next);
    }

    return current.toColor();
  }

  static double contrast(Color a, Color b) {
    final lumA = a.computeLuminance();
    final lumB = b.computeLuminance();
    final lighter = math.max(lumA, lumB);
    final darker = math.min(lumA, lumB);
    return (lighter + 0.05) / (darker + 0.05);
  }

  @override
  ArtPalette copyWith({
    Color? wall,
    Color? ink,
    Color? muted,
    Color? accent,
    Color? glow,
  }) {
    return ArtPalette(
      wall: wall ?? this.wall,
      ink: ink ?? this.ink,
      muted: muted ?? this.muted,
      accent: accent ?? this.accent,
      glow: glow ?? this.glow,
    );
  }

  @override
  ArtPalette lerp(ThemeExtension<ArtPalette>? other, double t) {
    if (other is! ArtPalette) return this;
    return ArtPalette(
      wall: Color.lerp(wall, other.wall, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      glow: Color.lerp(glow, other.glow, t)!,
    );
  }
}

extension ArtPaletteContext on BuildContext {
  ArtPalette get palette => Theme.of(this).extension<ArtPalette>()!;
}

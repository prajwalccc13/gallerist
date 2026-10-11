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

  factory ArtPalette.fromSeed(Color seed) {
    final source = HSLColor.fromColor(seed);
    final hue = source.hue;
    final sat = source.saturation;

    Color tone(double saturation, double lightness) => HSLColor.fromAHSL(
      1.0,
      hue,
      saturation.clamp(0.0, 1.0),
      lightness.clamp(0.0, 1.0),
    ).toColor();

    return ArtPalette(
      wall: tone(math.min(sat * 0.4, 0.22), 0.93),
      ink: tone(math.min(sat, 0.35), 0.13),
      muted: tone(math.min(sat, 0.20), 0.40),
      accent: tone(sat.clamp(0.35, 0.75), 0.40),
      glow: tone(sat.clamp(0.30, 0.80), 0.50),
    );
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
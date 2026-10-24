import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gallerist/theme/art_palette.dart';

void main() {
  for (final brightness in Brightness.values) {
    test('text is readable on the wall in ${brightness.name} mode', () {
      for (var hue = 0; hue < 360; hue += 5) {
        for (final saturation in [0.0, 0.3, 0.6, 1.0]) {
          final seed = HSLColor.fromAHSL(
            1,
            hue.toDouble(),
            saturation,
            0.5,
          ).toColor();
          final p = ArtPalette.fromSeed(seed, brightness);
          final where = 'hue $hue, saturation $saturation';

          expect(
            ArtPalette.contrast(p.ink, p.wall),
            greaterThanOrEqualTo(4.5),
            reason: 'ink, $where',
          );
          expect(
            ArtPalette.contrast(p.muted, p.wall),
            greaterThanOrEqualTo(4.5),
            reason: 'muted, $where',
          );
          expect(
            ArtPalette.contrast(p.accent, p.wall),
            greaterThanOrEqualTo(4.5),
            reason: 'accent, $where',
          );
        }
      }
    });
  }
}

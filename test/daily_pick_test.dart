import 'package:flutter_test/flutter_test.dart';

import 'package:gallerist/data/cleveland_artwork_repository.dart';

void main() {
  int pick(DateTime day) => ClevelandArtworkRepository.indexForDay(day, 62);

  test('gives the same painting all day', () {
    expect(
      pick(DateTime(2026, 10, 11, 7, 0)),
      pick(DateTime(2026, 10, 11, 23, 59)),
    );
  });

  test('shows every painting once before repeating', () {
    final seen = {for (var i = 0; i < 62; i++) pick(DateTime(2026, 1, 1 + i))};
    expect(seen.length, 62);
  });

  test('always gives a valid position', () {
    for (var i = 0; i < 1000; i++) {
      expect(pick(DateTime(2024, 1, 1 + i)), inInclusiveRange(0, 61));
    }
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gallerist/data/collection_repository.dart';

import 'fakes/fakes.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('notes survive being saved and loaded', () async {
    final prefs = await SharedPreferences.getInstance();
    final repository = LocalCollectionRepository(prefs);

    await repository.saveNotes({135382: 'Snow and a red cape'});
    final loaded = await repository.loadNotes();

    expect(loaded, {135382: 'Snow and a red cape'});
  });

  test('saved paintings survive being saved and loaded', () async {
    final prefs = await SharedPreferences.getInstance();
    final repository = LocalCollectionRepository(prefs);

    await repository.save([testArtwork, otherArtwork]);
    final loaded = await repository.load();

    expect(loaded.map((a) => a.id), [testArtwork.id, otherArtwork.id]);
  });
}

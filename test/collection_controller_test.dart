import 'package:flutter_test/flutter_test.dart';

import 'package:gallerist/state/collection_controller.dart';

import 'fakes/fakes.dart';

void main() {
  test('saving a painting adds it and stores it', () async {
    final repository = InMemoryCollectionRepository();
    final collection = CollectionController(repository);

    await collection.toggle(testArtwork);

    expect(collection.isSaved(testArtwork), isTrue);
    expect(repository.saved.map((a) => a.id), [testArtwork.id]);
  });

  test('saving it again removes it', () async {
    final collection = CollectionController(InMemoryCollectionRepository());

    await collection.toggle(testArtwork);
    await collection.toggle(testArtwork);

    expect(collection.isSaved(testArtwork), isFalse);
    expect(collection.artworks, isEmpty);
  });

  test('the newest save comes first', () async {
    final collection = CollectionController(InMemoryCollectionRepository());

    await collection.toggle(testArtwork);
    await collection.toggle(otherArtwork);

    expect(collection.artworks.map((a) => a.id), [otherArtwork.id, testArtwork.id]);
  });

  test('loads what was saved before', () async {
    final repository = InMemoryCollectionRepository()..saved = [testArtwork];
    final collection = CollectionController(repository);

    await collection.load();

    expect(collection.isSaved(testArtwork), isTrue);
  });

    test('writing a note saves the painting too', () async {
    final repository = InMemoryCollectionRepository();
    final collection = CollectionController(repository);

    await collection.saveNote(testArtwork, '  The red cape pulls my eye.  ');

    expect(collection.noteFor(testArtwork), 'The red cape pulls my eye.');
    expect(collection.isSaved(testArtwork), isTrue);
    expect(repository.notes[testArtwork.id], 'The red cape pulls my eye.');
  });

  test('clearing a note deletes it', () async {
    final collection = CollectionController(InMemoryCollectionRepository());

    await collection.saveNote(testArtwork, 'First thoughts');
    await collection.saveNote(testArtwork, '   ');

    expect(collection.noteFor(testArtwork), isNull);
  });

  test('removing a painting keeps its note', () async {
    final collection = CollectionController(InMemoryCollectionRepository());

    await collection.saveNote(testArtwork, 'Worth remembering');
    await collection.toggle(testArtwork);

    expect(collection.isSaved(testArtwork), isFalse);
    expect(collection.noteFor(testArtwork), 'Worth remembering');
  });
}

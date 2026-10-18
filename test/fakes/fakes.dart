import 'dart:ui' show Color;

import 'package:gallerist/data/artwork_colors.dart';
import 'package:gallerist/data/artwork_repository.dart';
import 'package:gallerist/models/artwork.dart';
import 'package:gallerist/data/collection_repository.dart';

const testArtwork = Artwork(
  id: 1,
  title: 'Water Lilies',
  imageUrl: 'https://example.com/water-lilies.jpg',
  artistDisplay: 'Claude Monet (French, 1840–1926)',
);

const testColor = Color(0xFF336699);

class FakeArtworkRepository implements ArtworkRepository {
  @override
  Future<Artwork> artworkForDay(DateTime day) async => testArtwork;
}

class FailingArtworkRepository implements ArtworkRepository {
  @override
  Future<Artwork> artworkForDay(DateTime day) async =>
      throw Exception('No internet');
}

class FlakyArtworkRepository implements ArtworkRepository {
  bool _hasFailed = false;

  @override
  Future<Artwork> artworkForDay(DateTime day) async {
    if (!_hasFailed) {
      _hasFailed = true;
      throw Exception('No internet');
    }
    return testArtwork;
  }
}

class FakeArtworkColors implements ArtworkColors {
  @override
  Future<Color?> seedFor(Artwork artwork) async => testColor;
}

const otherArtwork = Artwork(
  id: 2,
  title: 'The Red Kerchief',
  imageUrl: 'https://example.com/red-kerchief.jpg',
);

class InMemoryCollectionRepository implements CollectionRepository {
  List<Artwork> saved = [];
  Map<int, String> notes = {};

  @override
  Future<List<Artwork>> load() async => saved;

  @override
  Future<void> save(List<Artwork> artworks) async => saved = artworks;

  @override
  Future<Map<int, String>> loadNotes() async => notes;

  @override
  Future<void> saveNotes(Map<int, String> newNotes) async => notes = newNotes;
}

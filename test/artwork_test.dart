import 'package:flutter_test/flutter_test.dart';

import 'package:gallerist/models/artwork.dart';

void main() {
  final sampleJson = <String, dynamic>{
    'id': 135382,
    'title': 'The Red Kerchief',
    'creation_date': 'c. 1868-73',
    'technique': 'oil on fabric',
    'description': '<p>A painting of <em>Camille</em> &amp; snow.</p>',
    'creators': [
      {'description': 'Claude Monet (French, 1840-1926)'},
    ],
    'images': {
      'web': {
        'url': 'https://example.com/red-kerchief.jpg',
        'width': '723',
        'height': '900',
      },
    },
  };

  group('Artwork.fromJson', () {
    test('reads the basic fields', () {
      final art = Artwork.fromJson(sampleJson);
      expect(art.id, 135382);
      expect(art.title, 'The Red Kerchief');
      expect(art.imageUrl, 'https://example.com/red-kerchief.jpg');
      expect(art.dateDisplay, 'c. 1868-73');
    });

    test('cuts the artist name out of the description', () {
      final art = Artwork.fromJson(sampleJson);
      expect(art.artistName, 'Claude Monet');
    });

    test('reads image sizes sent as strings', () {
      final art = Artwork.fromJson(sampleJson);
      expect(art.aspectRatio, closeTo(723 / 900, 0.0001));
    });

    test('capitalizes the technique', () {
      final art = Artwork.fromJson(sampleJson);
      expect(art.techniqueDisplay, 'Oil on fabric');
    });

    test('removes HTML from the description', () {
      final art = Artwork.fromJson(sampleJson);
      expect(art.description, 'A painting of Camille & snow.');
    });

    test('copes with no creators', () {
      final json = {...sampleJson, 'creators': <dynamic>[]};
      final art = Artwork.fromJson(json);
      expect(art.artistName, isNull);
    });

    test('survives being saved and read back', () {
      final original = Artwork.fromJson(sampleJson);
      final copy = Artwork.fromJson(original.toJson());
      expect(copy.title, original.title);
      expect(copy.artistName, original.artistName);
      expect(copy.imageUrl, original.imageUrl);
      expect(copy.aspectRatio, original.aspectRatio);
      expect(copy.description, original.description);
    });
  });
}

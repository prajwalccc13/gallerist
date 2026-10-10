import 'package:gallerist/data/cleveland_artwork_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gallerist/models/artwork.dart';
import 'package:gallerist/data/cleveland_api.dart';



const sample = r'''
{
  "id": 27992,
  "title": "A Sunday on La Grande Jatte — 1884",
  "image_id": "2d484387-2509-5e8e-2c43-22f9981972eb",
  "artist_display": "Georges Seurat\nFrench, 1859-1891",
  "date_display": "1884-86"
}
''';


Future<void> main() async {
  final repository = ClevelandArtworkRepository(ClevelandApi());
  final today = DateTime.now();

  for (var i = 0; i < 7; i++) {
    final day = DateTime(today.year, today.month, today.day + i);
    final art = await repository.artworkForDay(day);
    print('${day.day}/${day.month}: ${art.title}');
  }
}
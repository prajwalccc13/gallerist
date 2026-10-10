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
  final api = ClevelandApi();
  final art = await api.fetchArtwork(135382);
  print(art.title);
  print(art.artistName);
  print(art.dateDisplay);
  print(art.imageUrl);
}
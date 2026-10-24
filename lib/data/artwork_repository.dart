import 'package:gallerist/models/artwork.dart';

abstract class ArtworkRepository {
  Future<Artwork> artworkForDay(DateTime day);
  Future<List<Artwork>> search(String query);
}
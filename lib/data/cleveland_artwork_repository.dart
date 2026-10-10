import 'package:gallerist/data/artwork_repository.dart';
import 'package:gallerist/data/cleveland_api.dart';
import 'package:gallerist/models/artwork.dart';


class ClevelandArtworkRepository extends ArtworkRepository {
  ClevelandArtworkRepository(this._api);

  final ClevelandApi _api;

  @override
  Future<Artwork> artworkForDay(DateTime day) {
    return _api.fetchArtwork(135382);
  }
}
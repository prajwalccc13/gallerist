import 'package:gallerist/data/artwork_repository.dart';
import 'package:gallerist/models/artwork.dart';

class SampleArtworkRepository implements ArtworkRepository {
  @override
  Future<Artwork> artworkForDay(DateTime day) async {
    await Future.delayed(const Duration(seconds: 1));

    return const Artwork(
      id: 135382,
      title: 'The Red Kerchief',
      imageUrl:
          'https://openaccess-cdn.clevelandart.org/1958.39/1958.39_web.jpg',
      artistDisplay: 'Claude Monet (French, 1840-1926)',
      dateDisplay: 'c. 1868-73',
    );
  }

  @override
  Future<List<Artwork>> search(String query) async {
    return [await artworkForDay(DateTime.now())];
  }
}

import 'package:flutter/foundation.dart';

import 'package:gallerist/data/collection_repository.dart';
import 'package:gallerist/models/artwork.dart';

class CollectionController extends ChangeNotifier {
  CollectionController(this._repository);

  final CollectionRepository _repository;

  List<Artwork> _artworks = const [];
  List<Artwork> get artworks => _artworks;

  bool isSaved(Artwork artwork) => _artworks.any((a) => a.id == artwork.id);

  Future<void> load() async {
    _artworks = await _repository.load();
    notifyListeners();
  }

  Future<void> toggle(Artwork artwork) async {
    final updated = isSaved(artwork)
        ? _artworks.where((a) => a.id != artwork.id).toList()
        : [artwork, ..._artworks];

    _artworks = updated;
    notifyListeners();

    await _repository.save(updated);
  }
}
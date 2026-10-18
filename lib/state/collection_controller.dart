import 'package:flutter/foundation.dart';

import 'package:gallerist/data/collection_repository.dart';
import 'package:gallerist/models/artwork.dart';

class CollectionController extends ChangeNotifier {
  CollectionController(this._repository);

  final CollectionRepository _repository;

  List<Artwork> _artworks = const [];
  List<Artwork> get artworks => _artworks;

  Map<int, String> _notes = const {};

  String? noteFor(Artwork artwork) => _notes[artwork.id];

  bool isSaved(Artwork artwork) => _artworks.any((a) => a.id == artwork.id);

  Future<void> load() async {
    _artworks = await _repository.load();
    _notes = await _repository.loadNotes();
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

  Future<void> saveNote(Artwork artwork, String text) async {
    final trimmed = text.trim();
    final updated = {..._notes};

    if (trimmed.isEmpty) {
      updated.remove(artwork.id);
    } else {
      updated[artwork.id] = trimmed;
    }

    final alsoSave = trimmed.isNotEmpty && !isSaved(artwork);
    if (alsoSave) _artworks = [artwork, ..._artworks];

    _notes = updated;
    notifyListeners();

    await _repository.saveNotes(updated);
    if (alsoSave) await _repository.save(_artworks);
  }
}

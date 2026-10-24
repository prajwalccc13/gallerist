import 'package:flutter/foundation.dart';

import 'package:gallerist/data/artwork_repository.dart';
import 'package:gallerist/models/artwork.dart';
import 'package:gallerist/models/room.dart';
import 'package:gallerist/state/today_controller.dart' show LoadStatus;


class RoomController extends ChangeNotifier {
  RoomController(this._repository, this.room);

  final ArtworkRepository _repository;
  final Room room;

  LoadStatus _status = LoadStatus.loading;
  List<Artwork> _artworks = const [];
  bool _disposed = false;

  LoadStatus get status => _status;
  List<Artwork> get artworks => _artworks;

  Future<void> load() async {
    _status = LoadStatus.loading;
    _notify();

    try {
      _artworks = await _repository.search(room.query);
      _status = LoadStatus.ready;
    } catch (e) {
      debugPrint('Could not open the room: $e');
      _status = LoadStatus.error;
    }

    _notify();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
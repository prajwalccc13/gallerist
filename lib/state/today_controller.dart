import 'package:flutter/foundation.dart';

import 'package:gallerist/data/artwork_repository.dart';
import 'package:gallerist/models/artwork.dart';


enum LoadStatus { loading, ready, error }


class TodayController extends ChangeNotifier {
  TodayController(this._repository);

  final ArtworkRepository _repository;

  LoadStatus _status = LoadStatus.loading;
  Artwork? _artwork;
  String? _errorMessage;

  LoadStatus get status => _status;
  Artwork? get artwork => _artwork;
  String? get errorMessage => _errorMessage;

  Future<void> load() async {
    debugPrint('load() started');
    _status = LoadStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _artwork = await _repository.artworkForDay(DateTime.now());
      _status = LoadStatus.ready;
    } catch (e) {
      debugPrint('Loading failed: $e');
      _errorMessage = 'Couldn\'t reach the museum. '
          'Check your connection and try again.';
      _status = LoadStatus.error;
    }

    notifyListeners();
  }
}
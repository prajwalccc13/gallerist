import 'dart:ui' show Color;

import 'package:flutter/foundation.dart';

import 'package:gallerist/data/artwork_colors.dart';
import 'package:gallerist/data/artwork_repository.dart';
import 'package:gallerist/models/artwork.dart';


enum LoadStatus { loading, ready, error }


class TodayController extends ChangeNotifier {
  TodayController(this._repository, this._colors);

  final ArtworkRepository _repository;
  final ArtworkColors _colors;

  LoadStatus _status = LoadStatus.loading;
  Artwork? _artwork;
  String? _errorMessage;
  Color? _seedColor;

  Color? get seedColor => _seedColor;
  LoadStatus get status => _status;
  Artwork? get artwork => _artwork;
  String? get errorMessage => _errorMessage;

  Future<void> load() async {
    _status = LoadStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final artwork = await _repository.artworkForDay(DateTime.now());
      _artwork = artwork;
      _status = LoadStatus.ready;
      notifyListeners();

      _seedColor = await _colors.seedFor(artwork);
    } catch (e) {
      _errorMessage = 'Couldn\'t reach the museum. '
          'Check your connection and try again.';
      _status = LoadStatus.error;
    }

    notifyListeners();
  }
}
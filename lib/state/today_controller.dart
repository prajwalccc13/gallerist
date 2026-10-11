import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:gallerist/data/artwork_repository.dart';
import 'package:gallerist/models/artwork.dart';


enum LoadStatus { loading, ready, error }


class TodayController extends ChangeNotifier {
  TodayController(this._repository);

  final ArtworkRepository _repository;

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

      _seedColor = await _colorFrom(artwork);
    } catch (e) {
      _errorMessage = 'Couldn\'t reach the museum. '
          'Check your connection and try again.';
      _status = LoadStatus.error;
    }

    notifyListeners();
  }

  Future<Color?> _colorFrom(Artwork artwork) async {
    try {
      final scheme = await ColorScheme.fromImageProvider(
        provider: CachedNetworkImageProvider(artwork.imageUrl),
        dynamicSchemeVariant: DynamicSchemeVariant.fidelity
      );
      return scheme.primary;
    } catch (e) {
      debugPrint('Could not read the painting\'s colors: $e');
      return null;
    }
  }
}
import 'dart:ui' show Color;

import 'package:flutter/foundation.dart';

import 'package:gallerist/data/artwork_colors.dart';
import 'package:gallerist/data/artwork_repository.dart';
import 'package:gallerist/models/artwork.dart';

enum LoadStatus { loading, ready, error }

class TodayController extends ChangeNotifier {
  TodayController(this._repository, this._colors);

  static const daysToShow = 30;

  final ArtworkRepository _repository;
  final ArtworkColors _colors;

  LoadStatus _status = LoadStatus.loading;
  List<Artwork> _days = const [];
  int _selected = 0;
  DateTime _today = DateTime.now();
  String? _errorMessage;
  Color? _seedColor;

  LoadStatus get status => _status;
  List<Artwork> get days => _days;
  int get selected => _selected;
  Artwork? get artwork => _days.isEmpty ? null : _days[_selected];
  String? get errorMessage => _errorMessage;
  Color? get seedColor => _seedColor;

  DateTime dayAt(int index) =>
      DateTime(_today.year, _today.month, _today.day - index);

  Future<void> load() async {
    _status = LoadStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _today = DateTime.now();
      final days = <Artwork>[];
      for (var i = 0; i < daysToShow; i++) {
        days.add(await _repository.artworkForDay(dayAt(i)));
      }
      _days = days;
      _selected = 0;
      _status = LoadStatus.ready;
      notifyListeners();

      _seedColor = await _colors.seedFor(_days[0]);
    } catch (e) {
      debugPrint('Loading failed: $e');
      _errorMessage =
          'Couldn\'t reach the museum. '
          'Check your connection and try again.';
      _status = LoadStatus.error;
    }

    notifyListeners();
  }

  Future<void> selectDay(int index) async {
    if (index == _selected) return;
    _selected = index;
    notifyListeners();

    final color = await _colors.seedFor(_days[index]);
    if (index != _selected) return;

    _seedColor = color;
    notifyListeners();
  }
}

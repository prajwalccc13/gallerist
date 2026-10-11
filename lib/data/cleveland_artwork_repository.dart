import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:gallerist/data/artwork_repository.dart';
import 'package:gallerist/data/cleveland_api.dart';
import 'package:gallerist/models/artwork.dart';

class ClevelandArtworkRepository extends ArtworkRepository {
  ClevelandArtworkRepository(this._api, this._prefs);

  final ClevelandApi _api;
  final SharedPreferences _prefs;
  List<Artwork>? _paintings;

  static const _paintingsKey = 'paintings_v3';
  static const _savedAtKey = 'paintings_saved_at_v3';
  static const _maxAge = Duration(days: 30);

  @override
  Future<Artwork> artworkForDay(DateTime day) async {
    final paintings = await _loadPaintings();
    return paintings[indexForDay(day, paintings.length)];
  }

  Future<List<Artwork>> _loadPaintings() async {
    // From memory
    final inMemory = _paintings;
    if (inMemory != null) return inMemory;

    // From local storage
    final saved = _readSaved();
    if (saved != null && _isSavedListFresh()) {
      _paintings = saved;
      return saved;
    }

    // From the museum API
    try {
      final fetched = await _api.fetchHighlights();
      if (fetched.isEmpty) {
        throw Exception('The museum returned no paintings');
      }

      fetched.sort((a, b) => a.id.compareTo(b.id));
      await _save(fetched);
      _paintings = fetched;
      return fetched;
    } catch (e) {
      // If there is old list then show it rather than error screen.
      if (saved != null) {
        _paintings = saved;
        return saved;
      }
      rethrow;
    }
  }

  List<Artwork>? _readSaved() {
    final text = _prefs.getString(_paintingsKey);
    if (text == null) return null;

    try {
      final list = jsonDecode(text) as List<dynamic>;
      final paintings = list
          .whereType<Map<String, dynamic>>()
          .map((json) => Artwork.fromJson(json))
          .toList();

      return paintings.isEmpty ? null : paintings;
    } catch (e) {
      // The saved data is damaged. Treat it as missing.
      return null;
    }
  }

  bool _isSavedListFresh() {
    final savedAt = _prefs.getInt(_savedAtKey);
    if (savedAt == null) return false;

    final age = DateTime.now().difference(
      DateTime.fromMicrosecondsSinceEpoch(savedAt),
    );

    return age < _maxAge;
  }

  Future<void> _save(List<Artwork> paintings) async {
    final text = jsonEncode(paintings.map((a) => a.toJson()).toList());
    await _prefs.setString(_paintingsKey, text);
    await _prefs.setInt(_savedAtKey, DateTime.now().millisecondsSinceEpoch);
  }

  static int indexForDay(DateTime day, int count) {
    final dayNumber = DateTime.utc(
      day.year,
      day.month,
      day.day,
    ).difference(DateTime(2024, 1, 1)).inDays;
    return (dayNumber * 7919) % count;
  }
}

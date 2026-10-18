import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gallerist/models/artwork.dart';

abstract class CollectionRepository {
  Future<List<Artwork>> load();
  Future<void> save(List<Artwork> artworks);
}

class LocalCollectionRepository implements CollectionRepository {
  LocalCollectionRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _key = 'collection_v1';

  @override
  Future<List<Artwork>> load() async {
    final text = _prefs.getString(_key);
    if (text == null) return [];

    try {
      final list = jsonDecode(text) as List<dynamic>;
      return list
          .whereType<Map<String, dynamic>>()
          .map((json) => Artwork.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Could not read the collection: $e');
      return [];
    }
  }

  @override
  Future<void> save(List<Artwork> artworks) async {
    final text = jsonEncode(artworks.map((a) => a.toJson()).toList());
    await _prefs.setString(_key, text);
  }
}
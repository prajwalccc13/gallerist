import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:gallerist/models/artwork.dart';

class ClevelandApi {
  static const _host = 'openaccess-api.clevelandart.org';
  static const _fields =
      'id,title,creators,creation_date,images,technique,description,did_you_know';

  Future<Artwork> fetchArtwork(int id) async {
    final body = await _getJson(Uri.https(_host, '/api/artworks/$id'));
    final data = body['data'] as Map<String, dynamic>;

    if (data['images'] == null) {
      throw Exception('Artwork $id has no image');
    }

    return Artwork.fromJson(body['data']);
  }

  // Future<List<Artwork>> fetchHighlights() async {
  //   final url = Uri.https(
  //     _host,
  //     '/api/artworks/',
  //     {
  //       'type': 'Painting',
  //       'has_image': '1',
  //       'cc0': '1',
  //       'highlight': '1',
  //       'limit': '200',
  //       'fields': 'id,title,creators,creation_date,images,technique,description,did_you_know',
  //     }
  //   );

  //   final body = await _getJson(url);
  //   final data = body['data'] as List<dynamic>;

  //   return data
  //     .whereType<Map<String, dynamic>>()
  //     .where((json) => json['images'] != null)
  //     .map((json) => Artwork.fromJson(json))
  //     .toList();
  // }

  Future<List<Artwork>> fetchHighlights() =>
      _fetchPaintings({'highlight': '1', 'limit': '200'});

  Future<List<Artwork>> search(String query) =>
      _fetchPaintings({'q': query, 'limit': '60'});

  Future<List<Artwork>> _fetchPaintings(Map<String, String> extra) async {
    final url = Uri.https(_host, '/api/artworks/', {
      'type': 'Painting',
      'has_image': '1',
      'cc0': '1',
      'fields': _fields,
      ...extra,
    });

    final body = await _getJson(url);
    final data = body['data'] as List<dynamic>;

    return data
        .whereType<Map<String, dynamic>>()
        .where((json) => json['images'] != null)
        .map((json) => Artwork.fromJson(json))
        .toList();
  }

  Future<Map<String, dynamic>> _getJson(Uri url) async {
    // On the web, ask for a URL the phone app never uses. The museum's cache
    // ignores the Origin header, so a copy stored for the phone app (without
    // CORS permission) would be given to browsers too, and they'd block it.
    // Browsers always send Origin, so every copy cached for these URLs has
    // the CORS header.
    final requestUrl = kIsWeb
        ? url.replace(
            queryParameters: {...url.queryParameters, 'client': 'web'},
          )
        : url;
    final response = await http.get(requestUrl).timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('The museum answered ${response.statusCode}');
    }

    return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
  }
}

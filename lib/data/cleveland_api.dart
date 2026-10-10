import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:gallerist/models/artwork.dart';


class ClevelandApi {
  static const _host = 'openaccess-api.clevelandart.org';


  Future<Artwork> fetchArtwork(int id) async {
    final body = await _getJson(Uri.https(_host, '/api/artworks/$id'));
    final data = body['data'] as Map<String, dynamic>;
    

    if (data['images'] == null) {
      throw Exception('Artwork $id has no image');
    }
    
    return Artwork.fromJson(body['data']);
  }

  Future<List<Artwork>> fetchHighlights() async {
    final url = Uri.https(
      _host, 
      '/api/artworks/', 
      {
        'type': 'Painting',
        'has_image': '1',
        'cc0': '1',
        'highlight': '1',
        'limit': '200',
        'fields': 'id,title,creators,creation_date,images',
      }
    );

    final body = await _getJson(url);
    final data = body['data'] as List<dynamic>;

    return data 
      .whereType<Map<String, dynamic>>()
      .where((json) => json['images'] != null)
      .map((json) => Artwork.fromJson(json))
      .toList();
  }


  Future<Map<String, dynamic>> _getJson(Uri url) async {
    final response = await http
      .get(url)
      .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('The museum answered ${response.statusCode}');
    }

    return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
  }
}
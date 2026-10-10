import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:gallerist/models/artwork.dart';


class ClevelandApi {
  Future<Artwork> fetchArtwork(int id) async {
    final url = Uri.https(
      'openaccess-api.clevelandart.org',
      '/api/artworks/$id',
    );

    final response = await http.get(
      url
    );

    if (response.statusCode != 200) {
      throw Exception('The museum answered ${response.statusCode}');
    }

    final body = 
      jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    
    final data = body['data'] as Map<String, dynamic>;

    if (data['images'] == null) {
      throw Exception('Artwork $id has no image');
    }
    
    return Artwork.fromJson(body['data']);
  }
}
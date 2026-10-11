import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:gallerist/models/artwork.dart';

abstract class ArtworkColors {
  Future<Color?> seedFor(Artwork artwork);
}

class ImageArtworkColors implements ArtworkColors {
  @override
  Future<Color?> seedFor(Artwork artwork) async {
    try {
      final scheme = await ColorScheme.fromImageProvider(
        provider: CachedNetworkImageProvider(artwork.imageUrl),
        dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
      );
      return scheme.primary;
    } catch (e) {
      debugPrint('Could not read the painting\'s colors: $e');
      return null;
    }
  }
}
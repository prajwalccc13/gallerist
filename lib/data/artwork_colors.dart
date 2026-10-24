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

/// Used on the web, where browsers won't let us read the museum's image
/// pixels. Returning null means "no painting color", so the app keeps its
/// calm default palette (AppTheme.fallbackSeed).
class NoArtworkColors implements ArtworkColors {
  const NoArtworkColors();

  @override
  Future<Color?> seedFor(Artwork artwork) async => null;
}

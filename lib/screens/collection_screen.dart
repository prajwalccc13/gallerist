import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gallerist/models/artwork.dart';
import 'package:gallerist/state/collection_controller.dart';
import 'package:gallerist/theme/app_theme.dart';
import 'package:gallerist/theme/art_palette.dart';
import 'package:gallerist/widgets/artwork_grid.dart';
import 'package:gallerist/widgets/empty_state.dart';

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final artworks = context.watch<CollectionController>().artworks;
    final count = artworks.length;

    if (artworks.isEmpty) {
      return const Scaffold(
        body: SafeArea(
          child: EmptyState(
            title: 'Your collection',
            message:
                'Save a painting you love, and it will wait for you '
                'here, along with any notes you write about it.',
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your collection',
                    style: AppText.title(palette).copyWith(fontSize: 34),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    count == 1 ? '1 painting' : '$count paintings',
                    style: AppText.date(palette),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ArtworkGrid(
                artworks: artworks,
                heroPrefix: 'collection',
                onLongPress: _removeFromCollection,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _removeFromCollection(BuildContext context, Artwork artwork) {
  final collection = context.read<CollectionController>();
  final messenger = ScaffoldMessenger.of(context);

  collection.toggle(artwork);

  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text('Removed “${artwork.title}”'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => collection.toggle(artwork),
        ),
      ),
    );
}

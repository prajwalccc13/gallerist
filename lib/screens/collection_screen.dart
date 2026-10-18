import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import 'package:gallerist/models/artwork.dart';
import 'package:gallerist/screens/viewer_screen.dart';
import 'package:gallerist/state/collection_controller.dart';
import 'package:gallerist/theme/app_theme.dart';
import 'package:gallerist/theme/art_palette.dart';
import 'package:gallerist/widgets/empty_state.dart';

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final artworks = context.watch<CollectionController>().artworks;

    return Scaffold(
      body: SafeArea(
        child: artworks.isEmpty
            ? const EmptyState(
                title: 'Your collection',
                message: 'Save a painting you love, and it will wait for you '
                    'here, along with any notes you write about it.',
              )
            : _CollectionGrid(artworks: artworks),
      ),
    );
  }
}

class _CollectionGrid extends StatelessWidget {
  const _CollectionGrid({required this.artworks});

  final List<Artwork> artworks;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final count = artworks.length;

    return Column(
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
          child: MasonryGridView.count(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
            crossAxisCount: 2,
            mainAxisSpacing: 24,
            crossAxisSpacing: 16,
            itemCount: count,
            itemBuilder: (context, index) => _CollectionTile(
              key: ValueKey(artworks[index].id),
              artwork: artworks[index],
            ),
          ),
        ),
      ],
    );
  }
}

class _CollectionTile extends StatelessWidget {
  const _CollectionTile({super.key, required this.artwork});

  final Artwork artwork;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final heroTag = 'collection-${artwork.id}';
    final artistName = artwork.artistName;
    final placeholder = ColoredBox(color: palette.muted.withValues(alpha: 0.12));

    return GestureDetector(
      onTap: () => Navigator.of(context)
          .push(ViewerScreen.route(artwork, heroTag: heroTag)),
      onLongPress: () => _remove(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: artwork.aspectRatio,
            child: Hero(
              tag: heroTag,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: CachedNetworkImage(
                  imageUrl: artwork.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => placeholder,
                  errorWidget: (context, url, error) => placeholder,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            artwork.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppText.labelValue(palette)
                .copyWith(fontWeight: FontWeight.w600),
          ),
          if (artistName != null)
            Text(
              artistName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.caption(palette),
            ),
        ],
      ),
    );
  }

  void _remove(BuildContext context) {
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
}
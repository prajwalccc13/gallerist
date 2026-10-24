import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gallerist/screens/artwork_screen.dart';
import 'package:provider/provider.dart';

import 'package:gallerist/models/artwork.dart';
import 'package:gallerist/state/collection_controller.dart';
import 'package:gallerist/theme/app_theme.dart';
import 'package:gallerist/theme/art_palette.dart';
import 'package:gallerist/widgets/note_sheet.dart';

typedef ArtworkAction = void Function(BuildContext context, Artwork artwork);

class ArtworkGrid extends StatelessWidget {
  const ArtworkGrid({
    super.key,
    required this.artworks,
    required this.heroPrefix,
    this.onLongPress,
  });

  final List<Artwork> artworks;
  final String heroPrefix;
  final ArtworkAction? onLongPress;

  @override
  Widget build(BuildContext context) {
    final longPress = onLongPress;

    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 24,
      crossAxisSpacing: 16,
      itemCount: artworks.length,
      itemBuilder: (context, index) {
        final artwork = artworks[index];
        return ArtworkTile(
          key: ValueKey(artwork.id),
          artwork: artwork,
          heroTag: '$heroPrefix-${artwork.id}',
          onLongPress: longPress == null
              ? null
              : () => longPress(context, artwork),
        );
      },
    );
  }
}

class ArtworkTile extends StatelessWidget {
  const ArtworkTile({
    super.key,
    required this.artwork,
    required this.heroTag,
    this.onLongPress,
  });

  final Artwork artwork;
  final String heroTag;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final artistName = artwork.artistName;
    final note = context.select<CollectionController, String?>(
      (collection) => collection.noteFor(artwork),
    );
    final placeholder = ColoredBox(
      color: palette.muted.withValues(alpha: 0.12),
    );

    return GestureDetector(
      onTap: () =>
          Navigator.of(context)
              .push(ArtworkScreen.route(artwork, heroTag: heroTag)),
      onLongPress: onLongPress,
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
          if (note != null)
            GestureDetector(
              onTap: () => NoteSheet.show(context, artwork),
              child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  '“$note”',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.note(palette)
                      .copyWith(fontSize: 15, height: 1.3),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

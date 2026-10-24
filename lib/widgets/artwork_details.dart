import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import 'package:gallerist/models/artwork.dart';
import 'package:gallerist/screens/viewer_screen.dart';
import 'package:gallerist/state/collection_controller.dart';
import 'package:gallerist/theme/app_theme.dart';
import 'package:gallerist/theme/art_palette.dart';
import 'package:gallerist/widgets/note_sheet.dart';
import 'package:gallerist/widgets/wall_label.dart';

class ArtworkDetails extends StatelessWidget {
  const ArtworkDetails({
    super.key,
    required this.artwork,
    required this.heroTag,
    this.header,
  });

  final Artwork artwork;
  final String heroTag;
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final maxImageHeight = MediaQuery.sizeOf(context).height * 0.55;
    final header = this.header;
    final artistName = artwork.artistName;
    final dateDisplay = artwork.dateDisplay;
    final description = artwork.description;
    final didYouKnow = artwork.didYouKnow;

    final details = <Widget>[
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(artwork.title, style: AppText.title(palette))),
          const SizedBox(width: 8),
          _SaveButton(artwork: artwork),
        ],
      ),
      const SizedBox(height: 16),
      if (artistName != null) Text(artistName, style: AppText.artist(palette)),
      const SizedBox(height: 32),
      WallLabel(
        entries: {'Date': dateDisplay, 'Medium': artwork.techniqueDisplay},
      ),
      const SizedBox(height: 16),
      _NoteSection(artwork: artwork),
      if (description != null) ...[
        const SizedBox(height: 24),
        Text('About this work', style: AppText.sectionTitle(palette)),
        const SizedBox(height: 12),
        Text(description, style: AppText.body(palette)),
      ],
      if (didYouKnow != null) ...[
        const SizedBox(height: 28),
        Text('Did you know?', style: AppText.sectionTitle(palette)),
        const SizedBox(height: 12),
        Text(didYouKnow, style: AppText.body(palette)),
      ],
      const SizedBox(height: 40),
      Text(
        'Image and text courtesy of the Cleveland Museum of Art.',
        style: AppText.caption(palette),
      ),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 48),
      children: [
        if (header != null) ...[header, const SizedBox(height: 32)],
        _FramedArtwork(
          artwork: artwork,
          heroTag: heroTag,
          maxHeight: maxImageHeight,
        ),
        const SizedBox(height: 32),
        ...(reduceMotion
            ? details
            : details
                  .animate(interval: 60.ms)
                  .fadeIn(duration: 500.ms, curve: Curves.easeOut)
                  .slideY(
                    begin: 0.08,
                    end: 0,
                    duration: 500.ms,
                    curve: Curves.easeOutCubic,
                  )),
      ],
    );
  }
}

class _FramedArtwork extends StatelessWidget {
  const _FramedArtwork({
    required this.artwork,
    required this.heroTag,
    required this.maxHeight,
  });

  final Artwork artwork;
  final String heroTag;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: AspectRatio(
          aspectRatio: artwork.aspectRatio,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: palette.muted.withValues(alpha: 0.12),
              boxShadow: [
                BoxShadow(
                  color: palette.glow.withValues(alpha: 0.32),
                  blurRadius: 56,
                  spreadRadius: -8,
                  offset: const Offset(0, 24),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Semantics(
              button: true,
              label: 'View ${artwork.title} full screen',
              child: GestureDetector(
                onTap: () =>
                    Navigator.of(context)
                        .push(ViewerScreen.route(artwork, heroTag: heroTag)),
                child: Hero(
                  tag: heroTag,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: CachedNetworkImage(
                      imageUrl: artwork.imageUrl,
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 600),
                      fadeInCurve: Curves.easeOut,
                      placeholder: (context, url) => const SizedBox.shrink(),
                      errorWidget: (context, url, error) =>
                          const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.artwork});

  final Artwork artwork;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final saved = context.select<CollectionController, bool>(
      (collection) => collection.isSaved(artwork),
    );

    return IconButton(
      tooltip: saved ? 'Remove from collection' : 'Save to collection',
      onPressed: () => context.read<CollectionController>().toggle(artwork),
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) =>
            ScaleTransition(scale: animation, child: child),
        child: Icon(
          saved ? Icons.bookmark : Icons.bookmark_border,
          key: ValueKey(saved),
          color: saved ? palette.accent : palette.muted,
        ),
      ),
    );
  }
}

class _NoteSection extends StatelessWidget {
  const _NoteSection({required this.artwork});

  final Artwork artwork;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final note = context.select<CollectionController, String?>(
      (collection) => collection.noteFor(artwork),
    );
    final linkStyle = TextButton.styleFrom(
      padding: EdgeInsets.zero,
      minimumSize: const Size(0, 40),
      alignment: Alignment.centerLeft,
    );

    if (note == null) {
      return TextButton.icon(
        onPressed: () => NoteSheet.show(context, artwork),
        style: linkStyle,
        icon: const Icon(Icons.edit_outlined, size: 18),
        label: const Text('Write a note'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Your note', style: AppText.sectionTitle(palette)),
        const SizedBox(height: 8),
        Text(note, style: AppText.note(palette)),
        TextButton(
          onPressed: () => NoteSheet.show(context, artwork),
          style: linkStyle,
          child: const Text('Edit note'),
        ),
      ],
    );
  }
}

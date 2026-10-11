import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:gallerist/theme/app_theme.dart';
import 'package:gallerist/theme/art_palette.dart';
import 'package:gallerist/models/artwork.dart';
import 'package:gallerist/state/today_controller.dart';
import 'package:gallerist/widgets/wall_label.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TodayController>();
    return Scaffold(
      body: SafeArea(
        child: switch (controller.status) {
          LoadStatus.loading => const Center(
            child: CircularProgressIndicator(),
          ),
          LoadStatus.error => _ErrorView(
            message: controller.errorMessage ?? '',
            onRetry: controller.load,
          ),
          LoadStatus.ready => _ArtworkView(artwork: controller.artwork!),
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            TextButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}

class _ArtworkView extends StatelessWidget {
  const _ArtworkView({required this.artwork});

  final Artwork artwork;

  @override
  Widget build(BuildContext context) {
    final maxImageHeight = MediaQuery.sizeOf(context).height * 0.55;
    final artistName = artwork.artistName;
    final dateDisplay = artwork.dateDisplay;
    final palette = context.palette;
    final description = artwork.description;
    final didYouKnow = artwork.didYouKnow;

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 48),
      children: [
        const _Masthead(),
        const SizedBox(height: 32),
        _FramedArtwork(artwork: artwork, maxHeight: maxImageHeight),
        const SizedBox(height: 32),
        Text(artwork.title, style: AppText.title(palette)),
        const SizedBox(height: 16),
        if (artistName != null)
          Text(artistName, style: AppText.artist(palette)),
        const SizedBox(height: 32),
        WallLabel(
          entries: {'Date': dateDisplay, 'Medium': artwork.techniqueDisplay},
        ),
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
      ],
    );
  }
}

class _Masthead extends StatelessWidget {
  const _Masthead();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text('Gallerist', style: AppText.wordmark((palette))),
        const Spacer(),
        Text(
          DateFormat('EEEE d MMMM').format(DateTime.now()),
          style: AppText.date((palette)),
        ),
      ],
    );
  }
}

class _FramedArtwork extends StatelessWidget {
  const _FramedArtwork({required this.artwork, required this.maxHeight});

  final Artwork artwork;
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Image.network(
                artwork.imageUrl,
                fit: BoxFit.cover,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) return child;
                  return AnimatedOpacity(
                    opacity: frame == null ? 0 : 1,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOut,
                    child: child,
                  );
                },
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:gallerist/theme/app_theme.dart';
import 'package:gallerist/theme/art_palette.dart';
import 'package:gallerist/models/artwork.dart';
import 'package:gallerist/state/today_controller.dart';
import 'package:gallerist/state/collection_controller.dart';
import 'package:gallerist/widgets/wall_label.dart';
import 'package:gallerist/screens/viewer_screen.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TodayController>();
    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: switch (controller.status) {
            LoadStatus.loading => const _LoadingView(key: ValueKey('loading')),
            LoadStatus.error => _ErrorView(
              key: const ValueKey('error'),
              message: controller.errorMessage ?? '',
              onRetry: controller.load,
            ),
            LoadStatus.ready => _DaysPager(
              key: const ValueKey('ready'),
              controller: controller,
            ),
          },
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({super.key, required this.message, required this.onRetry});

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
  const _ArtworkView({super.key, required this.artwork, required this.date});

  final Artwork artwork;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final maxImageHeight = MediaQuery.sizeOf(context).height * 0.55;
    final artistName = artwork.artistName;
    final dateDisplay = artwork.dateDisplay;
    final palette = context.palette;
    final description = artwork.description;
    final didYouKnow = artwork.didYouKnow;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

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
        _Masthead(date: date),
        const SizedBox(height: 32),
        _FramedArtwork(artwork: artwork, maxHeight: maxImageHeight),
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

class _DaysPager extends StatelessWidget {
  const _DaysPager({super.key, required this.controller});

  final TodayController controller;

  @override
  Widget build(BuildContext context) {
    final days = controller.days;

    return PageView.builder(
      reverse: true,
      itemCount: days.length,
      onPageChanged: controller.selectDay,
      itemBuilder: (context, index) => _ArtworkView(
        key: ValueKey(days[index].id),
        artwork: days[index],
        date: controller.dayAt(index),
      ),
    );
  }
}

class _Masthead extends StatelessWidget {
  const _Masthead({required this.date});

  final DateTime date;

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
          DateFormat('EEEE d MMMM').format(date),
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
            child: Semantics(
              button: true,
              label: 'View ${artwork.title} full screen',
              child: GestureDetector(
                onTap: () =>
                    Navigator.of(context).push(ViewerScreen.route(artwork)),
                child: Hero(
                  tag: artwork.heroTag,
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

class _LoadingView extends StatelessWidget {
  const _LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    final wordmark = Text(
      'Gallerist',
      style: AppText.wordmark(palette).copyWith(fontSize: 44),
    );

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (reduceMotion)
            wordmark
          else
            wordmark
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .fade(begin: 0.35, end: 1, duration: 1200.ms),
          const SizedBox(height: 12),
          Text('Finding today\'s painting', style: AppText.caption(palette)),
        ],
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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:gallerist/theme/app_theme.dart';
import 'package:gallerist/theme/art_palette.dart';
import 'package:gallerist/models/artwork.dart';
import 'package:gallerist/state/today_controller.dart';

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

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 48),
      children: [
        const _Masthead(),
        const SizedBox(height: 32),
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxImageHeight),
            child: Image.network(artwork.imageUrl),
          ),
        ),
        const SizedBox(height: 32),
        Text(artwork.title, style: AppText.title(palette)),
        const SizedBox(height: 16),
        if (artistName != null) Text(artistName, style: AppText.artist(palette)),
        if (dateDisplay != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(dateDisplay, style: AppText.detail(palette)),
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

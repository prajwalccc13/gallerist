import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          LoadStatus.loading => 
            const Center(child: CircularProgressIndicator()),
          LoadStatus.error => _ErrorView(
            message: controller.errorMessage ?? '', 
            onRetry: controller.load,
          ),
          LoadStatus.ready => _ArtworkView(artwork: controller.artwork!),
        }
        
      )
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
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Image.network(
          artwork.imageUrl,
          webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
        ),
        const SizedBox(height: 24),
        Text(artwork.title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(artwork.artistName ?? "Unknown Artist"),
        Text(artwork.dateDisplay ?? ''),
      ],
    );
  }
}
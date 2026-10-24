import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gallerist/widgets/artwork_details.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:gallerist/theme/app_theme.dart';
import 'package:gallerist/theme/art_palette.dart';
import 'package:gallerist/state/today_controller.dart';


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
      itemBuilder: (context, index) => ArtworkDetails(
        key: ValueKey(days[index].id),
        artwork: days[index],
        heroTag: days[index].heroTag,
        header: _Masthead(date: controller.dayAt(index)),
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

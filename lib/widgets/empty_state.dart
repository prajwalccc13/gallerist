import 'package:flutter/material.dart';

import 'package:gallerist/theme/app_theme.dart';
import 'package:gallerist/theme/art_palette.dart';


class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppText.sectionTitle(palette).copyWith(fontSize: 30)),
          const SizedBox(height: 12),
          Text(message, style: AppText.body(palette)),
        ],
      ),
    );
  }
}
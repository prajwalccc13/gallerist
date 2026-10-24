import 'package:flutter/material.dart';

import 'package:gallerist/models/room.dart';
import 'package:gallerist/screens/room_screen.dart';
import 'package:gallerist/theme/app_theme.dart';
import 'package:gallerist/theme/art_palette.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          children: [
            Text(
              'Explore',
              style: AppText.title(palette).copyWith(fontSize: 34),
            ),
            const SizedBox(height: 4),
            Text('Wander the museum by theme.', style: AppText.date(palette)),
            const SizedBox(height: 24),
            for (final room in Room.all) _RoomRow(room: room),
          ],
        ),
      ),
    );
  }
}

class _RoomRow extends StatelessWidget {
  const _RoomRow({required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return InkWell(
      onTap: () => Navigator.of(context).push(RoomScreen.route(room)),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.title,
                    style: AppText.sectionTitle(palette).copyWith(fontSize: 28),
                  ),
                  const SizedBox(height: 4),
                  Text(room.blurb, style: AppText.detail(palette)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: palette.muted),
          ],
        ),
      ),
    );
  }
}

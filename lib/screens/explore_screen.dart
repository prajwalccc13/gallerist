import 'package:flutter/material.dart';

import 'package:gallerist/models/room.dart';
import 'package:gallerist/screens/room_screen.dart';
import 'package:gallerist/theme/app_theme.dart';
import 'package:gallerist/theme/art_palette.dart';
import 'package:gallerist/widgets/room_motif_painter.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Block 1: the heading. SliverToBoxAdapter turns an ordinary
            // widget into a sliver.
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Explore',
                      style: AppText.title(palette).copyWith(fontSize: 34),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Wander the museum by theme.',
                      style: AppText.date(palette),
                    ),
                  ],
                ),
              ),
            ),

            // Block 2: the rooms, two per row, in tall 3:4 tiles.
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
              sliver: SliverGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 3 / 4, // width ÷ height
                children: [
                  for (final room in Room.all) _RoomTile(room: room),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoomTile extends StatelessWidget {
  const _RoomTile({required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    // Material gives the tile its background and shape, and lets InkWell
    // draw its ripple inside the rounded corners (clipBehavior).
    return Material(
      // A whisper of ink on the wall: darker in light mode, lighter in dark
      // mode, because ink is the opposite of the wall in both.
      color: palette.ink.withValues(alpha: 0.04),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(RoomScreen.route(room)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // The drawing takes all the space the text doesn't need.
              Expanded(
                child: CustomPaint(
                  painter: RoomMotifPainter(
                    motif: room.motif,
                    color: palette.accent.withValues(alpha: 0.7),
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                room.title,
                style: AppText.title(palette).copyWith(fontSize: 24),
              ),
              const SizedBox(height: 2),
              Text(
                room.blurb,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppText.caption(palette),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
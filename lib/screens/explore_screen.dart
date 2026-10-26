import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gallerist/models/room.dart';
import 'package:gallerist/screens/room_screen.dart';
import 'package:gallerist/theme/app_theme.dart';
import 'package:gallerist/theme/art_palette.dart';
import 'package:gallerist/widgets/room_motif_painter.dart';

import 'package:gallerist/data/artwork_repository.dart';
import 'package:gallerist/models/artwork.dart';
import 'package:gallerist/widgets/painting_image.dart';

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
                children: [for (final room in Room.all) _RoomTile(room: room)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoomTile extends StatefulWidget {
  const _RoomTile({required this.room});

  final Room room;

  @override
  State<_RoomTile> createState() => _RoomTileState();
}

class _RoomTileState extends State<_RoomTile> {
  late final Future<Artwork?> _cover = _findCover();

  Future<Artwork?> _findCover() async {
    try {
      final artworks = await context.read<ArtworkRepository>().search(
        widget.room.query,
      );
      return artworks.isEmpty ? null : artworks.first;
    } catch (error) {
      // Offline, or the search failed: return no painting, and the tile keeps
      // its drawing. The room screen has its own error view if they tap it.
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final room = widget.room;

    return Material(
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
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CustomPaint(
                      painter: RoomMotifPainter(
                        motif: widget.room.motif,
                        color: palette.accent.withValues(alpha: 0.7),
                      ),
                    ),
                     FutureBuilder<Artwork?>(
                      future: _cover,
                      builder: (context, snapshot) {
                        final cover = snapshot.data;
                        if (cover == null) return const SizedBox.shrink();
                        return _CoverDetail(artwork: cover);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                room.title,
                style: AppText.title(palette).copyWith(fontSize: 24),
              ),
              const SizedBox(height: 2),
              Text(
                widget.room.blurb,
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



class _CoverDetail extends StatelessWidget {
  const _CoverDetail({required this.artwork});

  final Artwork artwork;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      // Scaling up by 1.5 inside the clip shows the middle two-thirds of the
      // painting: a detail, not a thumbnail. Brushstrokes become visible.
      child: Transform.scale(
        scale: 1.5,
        child: PaintingImage(url: artwork.imageUrl),
      ),
    );
  }
}
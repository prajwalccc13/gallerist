import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gallerist/data/artwork_repository.dart';
import 'package:gallerist/models/room.dart';
import 'package:gallerist/state/room_controller.dart';
import 'package:gallerist/state/today_controller.dart' show LoadStatus;
import 'package:gallerist/theme/app_theme.dart';
import 'package:gallerist/theme/art_palette.dart';
import 'package:gallerist/widgets/artwork_grid.dart';
import 'package:gallerist/widgets/empty_state.dart';

class RoomScreen extends StatelessWidget {
  const RoomScreen({super.key});

  static Route<void> route(Room room) {
    return MaterialPageRoute<void>(
      builder: (context) => ChangeNotifierProvider(
        create: (context) =>
            RoomController(context.read<ArtworkRepository>(), room)..load(),
        child: const RoomScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RoomController>();
    final palette = context.palette;
    final room = controller.room;

    return Scaffold(
      appBar: AppBar(),
      body: switch (controller.status) {
        LoadStatus.loading => Center(
            child: Text('Opening the room…', style: AppText.caption(palette)),
          ),
        LoadStatus.error => _RoomError(onRetry: controller.load),
        LoadStatus.ready => controller.artworks.isEmpty
            ? EmptyState(
                title: room.title,
                message: 'This room is empty for now. Try another theme.',
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          room.title,
                          style: AppText.title(palette).copyWith(fontSize: 34),
                        ),
                        const SizedBox(height: 4),
                        Text(room.blurb, style: AppText.detail(palette)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ArtworkGrid(
                      artworks: controller.artworks,
                      heroPrefix: 'room-${room.query}',
                    ),
                  ),
                ],
              ),
      },
    );
  }
}

class _RoomError extends StatelessWidget {
  const _RoomError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('This room is closed', style: AppText.sectionTitle(palette)),
          const SizedBox(height: 12),
          Text(
            'Gallerist couldn\'t reach the museum. '
            'Check your connection, then try again.',
            style: AppText.body(palette),
          ),
          const SizedBox(height: 16),
          TextButton(onPressed: onRetry, child: const Text('Try again')),
        ],
      ),
    );
  }
}
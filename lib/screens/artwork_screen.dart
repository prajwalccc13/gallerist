import 'package:flutter/material.dart';
import 'package:gallerist/state/today_controller.dart';
import 'package:provider/provider.dart';

import 'package:gallerist/data/artwork_colors.dart';
import 'package:gallerist/models/artwork.dart';
import 'package:gallerist/theme/app_theme.dart';
import 'package:gallerist/widgets/artwork_details.dart';

class ArtworkScreen extends StatefulWidget {
  const ArtworkScreen({super.key, required this.artwork, required this.heroTag});

  final Artwork artwork;
  final String heroTag;

  static Route<void> route(Artwork artwork, {required String heroTag}) {
    return MaterialPageRoute<void>(
      builder: (_) => ArtworkScreen(artwork: artwork, heroTag: heroTag),
    );
  }

  @override
  State<ArtworkScreen> createState() => _ArtworkScreenState();
}

class _ArtworkScreenState extends State<ArtworkScreen> {
  late Color _seed;

  @override
  void initState() {
    super.initState();
    _seed = context.read<TodayController>().seedColor ?? AppTheme.fallbackSeed;
    _loadColors();
  }

  Future<void> _loadColors() async {
    final seed = await context.read<ArtworkColors>().seedFor(widget.artwork);
    if (!mounted || seed == null) return;
    setState(() => _seed = seed);
  }

  @override
  Widget build(BuildContext context) {

    return AnimatedTheme(
      data: AppTheme.build(
        _seed,
        brightness: MediaQuery.platformBrightnessOf(context),
      ),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOutCubic,
      child: Scaffold(
        appBar: AppBar(),
        body: ArtworkDetails(artwork: widget.artwork, heroTag: widget.heroTag),
      ),
    );
  }
}
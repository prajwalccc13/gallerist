import 'package:flutter/material.dart';
import 'package:gallerist/data/cleveland_api.dart';

import 'package:gallerist/models/artwork.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  final _api = ClevelandApi();

  bool _isLoading = true;
  Artwork? _artwork;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final artwork = await _api.fetchArtwork(135382);
      if (!mounted) return;
      setState(() {
        _artwork = artwork;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Loading failed: $e');
      if (!mounted) return;
      setState(() {
        _error =
            'Couldn\'t reach the museum. '
            'Check your connection and try again.';
        _isLoading = false;
      });
    }
  }

  void _retry() {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: _buildBody()));
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Show Error
    final error = _error;
    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(error, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              TextButton(onPressed: _retry, child: const Text('Try again')),
            ],
          ),
        ),
      );
    }

    // Show Artwork
    final artwork = _artwork!;
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gallerist/data/cleveland_api.dart';
import 'package:gallerist/data/cleveland_artwork_repository.dart';
import 'package:gallerist/screens/today_screen.dart';
import 'package:gallerist/state/today_controller.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TodayController(ClevelandArtworkRepository(ClevelandApi()))..load(),
      child: const GalleristApp(),
    ),
  );
}

class GalleristApp extends StatelessWidget {
  const GalleristApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TodayScreen(),
    );
  }
}
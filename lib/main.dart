import 'package:flutter/material.dart';
import 'package:gallerist/data/collection_repository.dart';
import 'package:gallerist/screens/shell_screen.dart';
import 'package:gallerist/state/collection_controller.dart';
import 'package:provider/provider.dart';
import 'package:gallerist/theme/app_theme.dart';

import 'package:gallerist/data/cleveland_api.dart';
import 'package:gallerist/data/cleveland_artwork_repository.dart';
import 'package:gallerist/data/artwork_colors.dart';
import 'package:gallerist/screens/today_screen.dart';
import 'package:gallerist/state/today_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TodayController(
            ClevelandArtworkRepository(ClevelandApi(), prefs),
            ImageArtworkColors(),
          )..load(),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              CollectionController(LocalCollectionRepository(prefs))..load(),
        ),
      ],
      child: const GalleristApp(),
    ),
  );
}

class GalleristApp extends StatelessWidget {
  const GalleristApp({super.key});

  @override
  Widget build(BuildContext context) {
    final seed = context.select<TodayController, Color?>(
      (controller) => controller.seedColor,
    );
    
    return MaterialApp(
      title:'Gallerist',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(seed ?? AppTheme.fallbackSeed),
      themeAnimationDuration: const Duration(milliseconds: 900),
      themeAnimationCurve: Curves.easeInOutCubic,
      scrollBehavior: const AppScrollBehavior(),
      home: const ShellScreen(),
    );
  }
}
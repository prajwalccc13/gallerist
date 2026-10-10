import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gallerist/theme/app_theme.dart';

import 'package:gallerist/data/cleveland_api.dart';
import 'package:gallerist/data/cleveland_artwork_repository.dart';
import 'package:gallerist/screens/today_screen.dart';
import 'package:gallerist/state/today_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ChangeNotifierProvider(
      create: (_) => TodayController(ClevelandArtworkRepository(ClevelandApi(), prefs))..load(),
      child: const GalleristApp(),
    ),
  );
}

class GalleristApp extends StatelessWidget {
  const GalleristApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'Gallerist',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: TodayScreen(),
    );
  }
}
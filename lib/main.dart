import 'package:flutter/material.dart';

import 'package:gallerist/screens/today_screen.dart';

void main() {
  runApp(const GalleristApp());
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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:gallerist/screens/collection_screen.dart';
import 'package:gallerist/screens/explore_screen.dart';
import 'package:gallerist/screens/today_screen.dart';

class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int _index = 0;
  final _visited = <int>{0};

  static const _screens = [TodayScreen(), CollectionScreen(), ExploreScreen()];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: IndexedStack(
          index: _index, 
          children: [
            for (var i = 0; i < _screens.length; i++)
      _visited.contains(i) ? _screens[i] : const SizedBox.shrink(),
          ]
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (index) => setState(() {
            _index = index;
            _visited.add(index);
          }),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.filter_frames_outlined),
              selectedIcon: Icon(Icons.filter_frames),
              label: 'Today',
            ),
            NavigationDestination(
              icon: Icon(Icons.bookmark_border),
              selectedIcon: Icon(Icons.bookmark),
              label: 'Collection',
            ),
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore),
              label: 'Explore',
            ),
          ],
        ),
      ),
    );
  }
}

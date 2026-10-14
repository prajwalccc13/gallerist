import 'package:flutter/material.dart';

import 'package:gallerist/widgets/empty_state.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: EmptyState(
          title: 'Explore',
          message: 'Wander through the museum\'s collection by theme. '
              'This room opens soon.',
        ),
      ),
    );
  }

}
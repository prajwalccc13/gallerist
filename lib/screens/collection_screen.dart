import 'package:flutter/material.dart';

import 'package:gallerist/widgets/empty_state.dart';


class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: EmptyState(
          title: 'Your Collection', 
          message: 'Save a painting you love, and it will wait for you here, '
            'along with any notes you write about it.',
        )
      ),
    );
  }

}
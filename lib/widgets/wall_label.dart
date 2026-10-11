import 'package:flutter/material.dart';

import 'package:gallerist/theme/app_theme.dart';
import 'package:gallerist/theme/art_palette.dart';

class WallLabel extends StatelessWidget {
  const WallLabel({super.key, required this.entries});

  final Map<String, String?> entries;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    final rows = entries.entries.where((entry) => entry.value != null).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final row in rows)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 88,
                  child: Text(row.key, style: AppText.labelKey(palette)),
                ),
                Expanded(
                  child: Text(row.value!, style: AppText.labelValue(palette)),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

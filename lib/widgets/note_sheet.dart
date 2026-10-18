import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gallerist/models/artwork.dart';
import 'package:gallerist/state/collection_controller.dart';
import 'package:gallerist/theme/app_theme.dart';
import 'package:gallerist/theme/art_palette.dart';

class NoteSheet extends StatefulWidget {
  const NoteSheet({super.key, required this.artwork, this.initialText});

  final Artwork artwork;
  final String? initialText;

  static Future<void> show(BuildContext context, Artwork artwork) {
    final initialText = context.read<CollectionController>().noteFor(artwork);
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => NoteSheet(artwork: artwork, initialText: initialText),
    );
  }

  @override
  State<NoteSheet> createState() => _NoteSheetState();
}

class _NoteSheetState extends State<NoteSheet> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialText);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    context.read<CollectionController>().saveNote(widget.artwork, _controller.text);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your note', style: AppText.sectionTitle(palette)),
            const SizedBox(height: 4),
            Text(
              widget.artwork.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.caption(palette),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              autofocus: true,
              minLines: 3,
              maxLines: 8,
              textCapitalization: TextCapitalization.sentences,
              style: AppText.note(palette),
              decoration: InputDecoration(
                hintText: 'What do you notice?',
                hintStyle: AppText.note(palette).copyWith(color: palette.muted),
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(foregroundColor: palette.muted),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                TextButton(onPressed: _save, child: const Text('Save note')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
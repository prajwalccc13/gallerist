import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// Shows a painting's image on any platform.
///
/// Phones and desktop: cached_network_image, so images work offline.
/// Web: the museum's image server doesn't allow browsers to read images
/// (no CORS header), so we let the browser show them with a plain HTML
/// <img> element, which is always allowed.


class PaintingImage extends StatelessWidget {
  const PaintingImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.placeholder,
  });

  final String url;
  final BoxFit fit;

  /// Shown while the image loads, and if it fails.
  final Widget? placeholder;

  @override
  Widget build(BuildContext context) {
    final fallback = placeholder ?? const SizedBox.shrink();

    if (kIsWeb) {
      return Image.network(
        url,
        fit: fit,
        // Try the normal way first; if CORS blocks it, use an <img> element.
        webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
        // Fade the image in once its first frame is ready, like on the phone.
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          return Stack(
            fit: StackFit.passthrough,
            children: [
              fallback,
              AnimatedOpacity(
                opacity: frame == null ? 0 : 1,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
                child: child,
              ),
            ],
          );
        },
        errorBuilder: (context, error, stackTrace) => fallback,
      );
    }

    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      fadeInDuration: const Duration(milliseconds: 600),
      placeholder: (context, url) => fallback,
      errorWidget: (context, url, error) => fallback,
    );
  }
}
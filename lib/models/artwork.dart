class Artwork {
  const Artwork({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.artistDisplay,
    this.dateDisplay,
    this.imageWidth,
    this.imageHeight,
    this.technique,
    this.description,
    this.didYouKnow,
  });

  final int id;
  final String title;
  final String imageUrl;
  final String? artistDisplay;
  final String? dateDisplay;
  final double? imageWidth;
  final double? imageHeight;
  final String? technique;
  final String? description;
  final String? didYouKnow;

  String? get artistName => artistDisplay?.split(' (').first;

  String get heroTag => 'artwork-$id';

  double get aspectRatio {
    final w = imageWidth;
    final h = imageHeight;
    if (w == null || h == null || w <= 0 || h <= 0) return 4 / 5;
    return w / h;
  }

  String? get techniqueDisplay {
    final t = technique;
    if (t == null || t.isEmpty) return null;
    return t[0].toUpperCase() + t.substring(1);
  }

  factory Artwork.fromJson(Map<String, dynamic> json) {
    final images = json['images'] as Map<String, dynamic>;
    final webImage = images['web'] as Map<String, dynamic>;

    final creators = (json['creators'] as List<dynamic>?) ?? const [];
    final firstCreator = creators.isEmpty
        ? null
        : creators.first as Map<String, dynamic>;

    return Artwork(
      id: json['id'] as int,
      title: (json['title'] as String?) ?? 'Untitled',
      imageUrl: webImage['url'] as String,
      artistDisplay: firstCreator?['description'] as String?,
      dateDisplay: json['date_display'] as String?,
      imageWidth: _toDouble(webImage['width']),
      imageHeight: _toDouble(webImage['height']),
      technique: json['technique'] as String?,
      description: _plainText(json['description'] as String?),
      didYouKnow: _plainText(json['did_you_know'] as String?),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'creation_date': dateDisplay,
    'creators': [
      if (artistDisplay != null) {'description': artistDisplay},
    ],
    'images': {
      'web': {'url': imageUrl},
    },
    'technique': technique,
    'description': description,
    'did_you_know': didYouKnow,
  };

  static double? _toDouble(Object? value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static String? _plainText(String? html) {
    if (html == null) return null;

    final text = html
      .replaceAll(RegExp(r'<[^>]+>'), '')
      .replaceAll('&amp;', '&')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll('&nbsp;', ' ')
      .trim();

    return text.isEmpty ? null : text;
  }
}

class Artwork {
  const Artwork({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.artistDisplay,
    this.dateDisplay,
  });

  final int id;
  final String title;
  final String imageUrl;
  final String? artistDisplay;
  final String? dateDisplay;

  String? get artistName => artistDisplay?.split(' (').first;

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
  };
}

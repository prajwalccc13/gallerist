class Room {
  const Room({required this.title, required this.query, required this.blurb});

  final String title;
  final String query;
  final String blurb;

  static const all = [
    Room(
      title: 'Snow',
      query: 'snow',
      blurb: 'Quiet landscapes under winter light.',
    ),
    Room(
      title: 'The Sea',
      query: 'sea',
      blurb: 'Harbours, storms and open water.',
    ),
    Room(
      title: 'Night',
      query: 'night',
      blurb: 'Moonlight, lamplight and the dark between.',
    ),
    Room(
      title: 'Gardens',
      query: 'garden',
      blurb: 'Paths, blossoms and afternoons outdoors.',
    ),
    Room(
      title: 'Flowers',
      query: 'flowers',
      blurb: 'Still lifes that never wilt.',
    ),
    Room(
      title: 'Faces',
      query: 'portrait',
      blurb: 'People who sat for a painter, and stayed.',
    ),
  ];
}

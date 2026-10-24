enum RoomMotif { snow, water, sea, night, garden, flowers, portrait }

class Room {
  const Room({required this.title, required this.query, required this.blurb, required this.motif});

  final String title;
  final String query;
  final String blurb;
  final RoomMotif motif;


  static const all = [
    Room(
      title: 'Snow',
      query: 'snow',
      blurb: 'Quiet landscapes under winter light.',
      motif: RoomMotif.snow,
    ),
    Room(
      title: 'Water',
      query: 'water',
      blurb: 'Harbours, storms and open water.',
      motif: RoomMotif.water,
    ),
    Room(
      title: 'The Sea',
      query: 'sea',
      blurb: 'Harbours, storms and open water.',
      motif: RoomMotif.sea,
    ),
    Room(
      title: 'Night',
      query: 'night',
      blurb: 'Moonlight, lamplight and the dark between.',
      motif: RoomMotif.night,
    ),
    Room(
      title: 'Gardens',
      query: 'garden',
      blurb: 'Paths, blossoms and afternoons outdoors.',
      motif: RoomMotif.garden,
    ),
    Room(
      title: 'Flowers',
      query: 'flowers',
      blurb: 'Still lifes that never wilt.',
      motif: RoomMotif.flowers,
    ),
    Room(
      title: 'Faces',
      query: 'portrait',
      blurb: 'People who sat for a painter, and stayed.',
      motif: RoomMotif.portrait,
    ),
  ];
}

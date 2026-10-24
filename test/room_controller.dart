import 'package:flutter_test/flutter_test.dart';

import 'package:gallerist/models/room.dart';
import 'package:gallerist/state/room_controller.dart';
import 'package:gallerist/state/today_controller.dart';

import 'fakes/fakes.dart';

void main() {
  const room = Room(title: 'Snow', query: 'snow', blurb: 'Winter light.');

  test('shows the paintings that match the room', () async {
    final controller = RoomController(FakeArtworkRepository(), room);

    await controller.load();

    expect(controller.status, LoadStatus.ready);
    expect(controller.artworks.length, 2);
  });

  test('a failure shows an error', () async {
    final controller = RoomController(FailingArtworkRepository(), room);

    await controller.load();

    expect(controller.status, LoadStatus.error);
  });

  test('leaving before the results arrive does not crash', () async {
    final controller = RoomController(SlowArtworkRepository(), room);

    final loading = controller.load();
    controller.dispose();
    await loading;
  });
}

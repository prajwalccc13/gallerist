import 'package:flutter_test/flutter_test.dart';

import 'package:gallerist/state/today_controller.dart';

import 'fakes/fakes.dart';

void main() {
  test('starts out loading', () {
    final controller =
        TodayController(FakeArtworkRepository(), FakeArtworkColors());
    expect(controller.status, LoadStatus.loading);
    expect(controller.artwork, isNull);
  });

  test('shows the painting and its color once loaded', () async {
    final controller =
        TodayController(FakeArtworkRepository(), FakeArtworkColors());

    await controller.load();

    expect(controller.status, LoadStatus.ready);
    expect(controller.artwork, testArtwork);
    expect(controller.seedColor, testColor);
  });

  test('shows the painting first, then its colors', () async {
    final controller =
        TodayController(FakeArtworkRepository(), FakeArtworkColors());
    final seen = <String>[];
    controller.addListener(() {
      seen.add('${controller.status.name}:${controller.seedColor != null}');
    });

    await controller.load();

    expect(seen, ['loading:false', 'ready:false', 'ready:true']);
  });

  test('a failure shows an error, not an endless spinner', () async {
    final controller =
        TodayController(FailingArtworkRepository(), FakeArtworkColors());

    await controller.load();

    expect(controller.status, LoadStatus.error);
    expect(controller.errorMessage, isNotNull);
  });

  test('"Try again" recovers after a failure', () async {
    final controller =
        TodayController(FlakyArtworkRepository(), FakeArtworkColors());

    await controller.load();
    expect(controller.status, LoadStatus.error);

    await controller.load();
    expect(controller.status, LoadStatus.ready);
    expect(controller.errorMessage, isNull);
  });
}
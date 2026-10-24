import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:gallerist/models/room.dart';

/// Draws a room's motif in thin lines, like a museum's printed floor plan.
class RoomMotifPainter extends CustomPainter {
  RoomMotifPainter({required this.motif, required this.color});

  final RoomMotif motif;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    // A Paint is the "pen": its color, its thickness, and whether shapes are
    // outlined (stroke) or filled (fill).
    final line = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.25
      ..strokeCap = StrokeCap.round; // soft line ends, like a fine pen

    final dot = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    switch (motif) {
      case RoomMotif.snow:
        _snow(canvas, size, dot);
      case RoomMotif.water:
        _water(canvas, size, line);
      case RoomMotif.sea:
        _sea(canvas, size, line);
      case RoomMotif.night:
        _night(canvas, size, line, dot);
      case RoomMotif.garden:
        _garden(canvas, size, line);
      case RoomMotif.flowers:
        _flowers(canvas, size, line);
      case RoomMotif.portrait:
        _portrait(canvas, size, line);
    }
  }

  /// Falling snow: dots of slightly different sizes.
  void _snow(Canvas canvas, Size size, Paint dot) {
    // A fixed seed (7) gives the same "random" snowfall every time.
    final random = math.Random(7);
    for (var i = 0; i < 40; i++) {
      final position = Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      );
      canvas.drawCircle(position, 0.8 + random.nextDouble() * 1.6, dot);
    }
  }

  /// Water: five gentle waves, one under another.
  void _water(Canvas canvas, Size size, Paint line) {
    for (var row = 0; row < 5; row++) {
      final y = size.height * (0.3 + row * 0.12);
      final path = Path()..moveTo(0, y);
      // A wave is many tiny straight lines that follow a sine curve.
      for (var x = 0.0; x <= size.width; x += 2) {
        final wave = math.sin(x / size.width * math.pi * 4 + row) * 4;
        path.lineTo(x, y + wave);
      }
      canvas.drawPath(path, line);
    }
  }

  /// The sea: a horizon, a sun, and small waves coming closer.
  void _sea(Canvas canvas, Size size, Paint line) {
    final horizon = size.height * 0.5;
    canvas.drawLine(Offset(0, horizon), Offset(size.width, horizon), line);
    canvas.drawCircle(
      Offset(size.width * 0.68, horizon - size.height * 0.14),
      size.width * 0.09,
      line,
    );
    for (var i = 0; i < 3; i++) {
      // Each wave is lower (closer to us) and wider than the one before.
      final y = horizon + size.height * (0.12 + i * 0.11);
      final width = size.width * (0.18 + i * 0.1);
      final x = size.width * (i.isEven ? 0.2 : 0.5);
      final wave = Path()
        ..moveTo(x, y)
        ..quadraticBezierTo(x + width / 2, y - 6, x + width, y);
      canvas.drawPath(wave, line);
    }
  }

  /// Night: a crescent moon and a few stars.
  void _night(Canvas canvas, Size size, Paint line, Paint dot) {
    final center = Offset(size.width * 0.6, size.height * 0.4);
    final radius = size.width * 0.18;
    // A crescent is one circle with a slightly moved circle cut out of it.
    final moon = Path.combine(
      PathOperation.difference,
      Path()..addOval(Rect.fromCircle(center: center, radius: radius)),
      Path()
        ..addOval(Rect.fromCircle(
          center: center + Offset(radius * 0.45, -radius * 0.25),
          radius: radius,
        )),
    );
    canvas.drawPath(moon, line);

    final random = math.Random(3);
    for (var i = 0; i < 14; i++) {
      final star = Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height * 0.85,
      );
      // Keep stars from landing on the moon.
      if ((star - center).distance < radius * 1.4) continue;
      canvas.drawCircle(star, 0.6 + random.nextDouble(), dot);
    }
  }

  /// A garden: stems of different heights, each with one leaf.
  void _garden(Canvas canvas, Size size, Paint line) {
    final ground = size.height * 0.85;
    for (var i = 0; i < 5; i++) {
      final x = size.width * (0.18 + i * 0.16);
      final top = size.height * (0.35 + (i % 2) * 0.12);
      final stem = Path()
        ..moveTo(x, ground)
        ..quadraticBezierTo(x + 8, (ground + top) / 2, x, top);
      canvas.drawPath(stem, line);

      // One leaf, on alternating sides of the stems.
      final side = i.isEven ? 1 : -1;
      final leafY = (ground + top) / 2;
      final leaf = Path()
        ..moveTo(x + 4, leafY)
        ..quadraticBezierTo(
            x + 4 + side * 14, leafY - 10, x + 4 + side * 18, leafY - 2)
        ..quadraticBezierTo(x + 4 + side * 10, leafY + 4, x + 4, leafY);
      canvas.drawPath(leaf, line);
    }
    canvas.drawLine(
      Offset(size.width * 0.1, ground),
      Offset(size.width * 0.9, ground),
      line,
    );
  }

  /// Flowers: one bloom of six petals on a curved stem.
  void _flowers(Canvas canvas, Size size, Paint line) {
    final center = Offset(size.width / 2, size.height * 0.42);
    final petal = size.width * 0.11;
    for (var i = 0; i < 6; i++) {
      // Move the canvas to the flower's center and turn it, then draw one
      // petal "upwards". Six turns of 60° make the whole bloom.
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(i * math.pi / 3);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(0, -petal),
          width: petal * 0.9,
          height: petal * 1.8,
        ),
        line,
      );
      canvas.restore(); // undo the move and turn before the next petal
    }
    canvas.drawCircle(center, petal * 0.35, line);

    final stem = Path()
      ..moveTo(center.dx, center.dy + petal * 2)
      ..quadraticBezierTo(
          center.dx - 10, size.height * 0.7, center.dx, size.height * 0.88);
    canvas.drawPath(stem, line);
  }

  /// A portrait: a frame, an oval mount, and a head and shoulders.
  void _portrait(Canvas canvas, Size size, Paint line) {
    final frame = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: size.width * 0.46,
      height: size.height * 0.62,
    );
    canvas.drawRect(frame, line);
    canvas.drawOval(frame.deflate(size.width * 0.06), line);

    final head = Offset(frame.center.dx, frame.center.dy - frame.height * 0.1);
    canvas.drawCircle(head, frame.width * 0.14, line);

    final shoulderY = frame.bottom - frame.height * 0.14;
    final shoulders = Path()
      ..moveTo(frame.center.dx - frame.width * 0.28, shoulderY)
      ..quadraticBezierTo(
        frame.center.dx,
        head.dy + frame.height * 0.08,
        frame.center.dx + frame.width * 0.28,
        shoulderY,
      );
    canvas.drawPath(shoulders, line);
  }

  // Flutter asks this whenever the widget is rebuilt: "do I need to draw
  // again?" Only if the motif or the color changed (for example, when the
  // room fades to a new palette). Otherwise it reuses the last drawing.
  @override
  bool shouldRepaint(RoomMotifPainter oldDelegate) =>
      oldDelegate.motif != motif || oldDelegate.color != color;
}
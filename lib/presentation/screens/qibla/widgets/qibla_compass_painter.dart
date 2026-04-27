import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Painter for the Qibla compass face.
///
/// - The dial rotates so the cardinal markers track magnetic north
///   (N stays pointing to where north is in the world, regardless of
///   how the phone is oriented).
/// - The needle points to the Qibla bearing (a fixed value for the
///   user's location).
/// - When the user rotates the phone so the needle points up, the
///   phone's top edge is facing Mecca.
///
/// Both `headingDeg` and `bearingDeg` are in the same convention:
/// degrees clockwise from north, range 0..360.
class QiblaCompassPainter extends CustomPainter {
  QiblaCompassPainter({
    required this.headingDeg,
    required this.bearingDeg,
    required this.cardinalLabels, // 4 strings: N, E, S, W in current locale
  });

  final double headingDeg;
  final double bearingDeg;
  final List<String> cardinalLabels;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - 8;

    // Outer face
    final facePaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = RadialGradient(
        colors: [
          AppColors.cardGreen,
          AppColors.primaryDarkGreen,
        ],
        stops: const [0.6, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, facePaint);

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = AppColors.gold.withValues(alpha: 0.6);
    canvas.drawCircle(center, radius, ringPaint);

    // Dial (rotates with -heading so N stays pointing to magnetic north)
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-headingDeg * pi / 180);

    // Tick marks every 6° (small) + every 30° (large) + every 90° (cardinal)
    for (var deg = 0; deg < 360; deg += 6) {
      final isCardinal = deg % 90 == 0;
      final isMajor = deg % 30 == 0;

      final tickStart = isCardinal
          ? radius - 18
          : (isMajor ? radius - 14 : radius - 8);
      final tickEnd = radius - 4;

      final tickPaint = Paint()
        ..strokeWidth = isCardinal ? 2.0 : (isMajor ? 1.4 : 0.8)
        ..color = isCardinal
            ? AppColors.gold
            : (isMajor
                ? AppColors.lightGold.withValues(alpha: 0.7)
                : AppColors.mutedText.withValues(alpha: 0.5));

      final rad = deg * pi / 180;
      final p1 = Offset(sin(rad) * tickStart, -cos(rad) * tickStart);
      final p2 = Offset(sin(rad) * tickEnd, -cos(rad) * tickEnd);
      canvas.drawLine(p1, p2, tickPaint);
    }

    // Cardinal labels
    final labelOffsets = [0.0, 90.0, 180.0, 270.0];
    for (var i = 0; i < 4; i++) {
      final deg = labelOffsets[i];
      final label = cardinalLabels[i];
      final isNorth = i == 0;
      final color = isNorth
          ? AppColors.gold
          : AppColors.lightGold.withValues(alpha: 0.85);
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            color: color,
            fontSize: isNorth ? 16 : 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final r = radius - 38;
      final rad = deg * pi / 180;
      final pos = Offset(
        sin(rad) * r - tp.width / 2,
        -cos(rad) * r - tp.height / 2,
      );
      tp.paint(canvas, pos);
    }

    canvas.restore();

    // Needle (rotates to qibla bearing — relative to screen-up, measured
    // from the static frame, since dial+heading have already been
    // composed via the inverse rotation).
    canvas.save();
    canvas.translate(center.dx, center.dy);
    final needleAngle = (bearingDeg - headingDeg) * pi / 180;
    canvas.rotate(needleAngle);
    _drawNeedle(canvas, radius);
    canvas.restore();

    // Center hub
    final hubPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.gold;
    canvas.drawCircle(center, 6, hubPaint);
    canvas.drawCircle(
      center,
      6,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = AppColors.primaryDarkGreen,
    );
  }

  void _drawNeedle(Canvas canvas, double radius) {
    final length = radius - 24;
    // Arrow body
    final path = Path()
      ..moveTo(0, -length)
      ..lineTo(8, -length * 0.55)
      ..lineTo(3, -length * 0.55)
      ..lineTo(3, length * 0.25)
      ..lineTo(-3, length * 0.25)
      ..lineTo(-3, -length * 0.55)
      ..lineTo(-8, -length * 0.55)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.fill
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.gold, AppColors.lightGold.withValues(alpha: 0.5)],
        ).createShader(Rect.fromLTWH(-8, -length, 16, length * 1.25)),
    );
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = AppColors.gold,
    );
  }

  @override
  bool shouldRepaint(covariant QiblaCompassPainter oldDelegate) {
    return oldDelegate.headingDeg != headingDeg ||
        oldDelegate.bearingDeg != bearingDeg;
  }
}

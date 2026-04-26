import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class MosqueSilhouette extends StatelessWidget {
  const MosqueSilhouette({
    super.key,
    this.opacity = 0.12,
    this.heightFactor = 0.55,
  });

  final double opacity;
  final double heightFactor;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return IgnorePointer(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          widthFactor: 1,
          heightFactor: heightFactor,
          child: Transform(
            alignment: Alignment.center,
            transform: isRtl
                ? (Matrix4.identity()..scaleByDouble(-1.0, 1.0, 1.0, 1.0))
                : Matrix4.identity(),
            child: CustomPaint(
              painter: _MosquePainter(opacity: opacity),
              size: Size.infinite,
            ),
          ),
        ),
      ),
    );
  }
}

class _MosquePainter extends CustomPainter {
  _MosquePainter({required this.opacity});

  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.cardGreen.withValues(alpha: opacity);
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppColors.gold.withValues(alpha: opacity);

    final cx = w / 2;
    final baseTop = h * 0.55;

    final building = Path()
      ..moveTo(w * 0.15, h)
      ..lineTo(w * 0.15, baseTop)
      ..lineTo(w * 0.85, baseTop)
      ..lineTo(w * 0.85, h)
      ..close();

    final archHeight = (h - baseTop) * 0.55;
    final archWidth = w * 0.16;
    for (final ax in [w * 0.30, w * 0.50, w * 0.70]) {
      final left = ax - archWidth / 2;
      final right = ax + archWidth / 2;
      final bottom = h;
      final top = bottom - archHeight;
      final arch = Path()
        ..moveTo(left, bottom)
        ..lineTo(left, top + archWidth / 2)
        ..arcToPoint(
          Offset(right, top + archWidth / 2),
          radius: Radius.circular(archWidth / 2),
          clockwise: true,
        )
        ..lineTo(right, bottom)
        ..close();
      building.addPath(arch, Offset.zero);
    }

    canvas.drawPath(building, fillPaint);
    canvas.drawPath(building, strokePaint);

    _drawOnionDome(
      canvas,
      cx: cx,
      baseY: baseTop,
      baseRadius: w * 0.14,
      domeHeight: h * 0.32,
      fill: fillPaint,
      stroke: strokePaint,
    );

    _drawOnionDome(
      canvas,
      cx: w * 0.27,
      baseY: baseTop,
      baseRadius: w * 0.075,
      domeHeight: h * 0.18,
      fill: fillPaint,
      stroke: strokePaint,
    );
    _drawOnionDome(
      canvas,
      cx: w * 0.73,
      baseY: baseTop,
      baseRadius: w * 0.075,
      domeHeight: h * 0.18,
      fill: fillPaint,
      stroke: strokePaint,
    );

    _drawMinaret(
      canvas,
      centerX: w * 0.10,
      baseY: h,
      shaftWidth: w * 0.025,
      totalHeight: h * 0.85,
      fill: fillPaint,
      stroke: strokePaint,
    );
    _drawMinaret(
      canvas,
      centerX: w * 0.90,
      baseY: h,
      shaftWidth: w * 0.025,
      totalHeight: h * 0.85,
      fill: fillPaint,
      stroke: strokePaint,
    );
  }

  void _drawOnionDome(
    Canvas canvas, {
    required double cx,
    required double baseY,
    required double baseRadius,
    required double domeHeight,
    required Paint fill,
    required Paint stroke,
  }) {
    final r = baseRadius;
    final h = domeHeight;
    final path = Path()
      ..moveTo(cx - r, baseY)
      ..cubicTo(
        cx - r * 1.35, baseY - h * 0.30,
        cx - r * 1.20, baseY - h * 0.62,
        cx - r * 0.45, baseY - h * 0.82,
      )
      ..quadraticBezierTo(
        cx, baseY - h * 0.95,
        cx + r * 0.45, baseY - h * 0.82,
      )
      ..cubicTo(
        cx + r * 1.20, baseY - h * 0.62,
        cx + r * 1.35, baseY - h * 0.30,
        cx + r, baseY,
      )
      ..close();
    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);

    final finialBaseY = baseY - h * 0.95;
    final spireH = h * 0.18;
    final spire = Path()
      ..moveTo(cx, finialBaseY - spireH)
      ..lineTo(cx - r * 0.08, finialBaseY)
      ..lineTo(cx + r * 0.08, finialBaseY)
      ..close();
    canvas.drawPath(spire, fill);
    canvas.drawPath(spire, stroke);
  }

  void _drawMinaret(
    Canvas canvas, {
    required double centerX,
    required double baseY,
    required double shaftWidth,
    required double totalHeight,
    required Paint fill,
    required Paint stroke,
  }) {
    final shaftTop = baseY - totalHeight * 0.78;
    final balconyY = baseY - totalHeight * 0.62;
    final balconyHeight = totalHeight * 0.04;
    final capH = totalHeight * 0.10;
    final spireH = totalHeight * 0.12;

    final shaft = Path()
      ..moveTo(centerX - shaftWidth / 2, baseY)
      ..lineTo(centerX - shaftWidth / 2, shaftTop)
      ..lineTo(centerX + shaftWidth / 2, shaftTop)
      ..lineTo(centerX + shaftWidth / 2, baseY)
      ..close();
    canvas.drawPath(shaft, fill);
    canvas.drawPath(shaft, stroke);

    final balcony = Rect.fromLTRB(
      centerX - shaftWidth * 1.3,
      balconyY,
      centerX + shaftWidth * 1.3,
      balconyY + balconyHeight,
    );
    canvas.drawRect(balcony, fill);
    canvas.drawRect(balcony, stroke);

    final cap = Path()
      ..moveTo(centerX - shaftWidth * 1.0, shaftTop)
      ..quadraticBezierTo(
        centerX, shaftTop - capH * 1.4,
        centerX + shaftWidth * 1.0, shaftTop,
      )
      ..close();
    canvas.drawPath(cap, fill);
    canvas.drawPath(cap, stroke);

    final capTopY = shaftTop - capH * 1.0;
    final spire = Path()
      ..moveTo(centerX, capTopY - spireH)
      ..lineTo(centerX - shaftWidth * 0.4, capTopY)
      ..lineTo(centerX + shaftWidth * 0.4, capTopY)
      ..close();
    canvas.drawPath(spire, fill);
    canvas.drawPath(spire, stroke);
  }

  @override
  bool shouldRepaint(covariant _MosquePainter oldDelegate) =>
      oldDelegate.opacity != opacity;
}

import 'package:flutter/material.dart';
import '../onboarding/onboarding_style.dart';

/// Decorative vector artwork stays crisp at phone and tablet sizes.
class InstitutionIllustration extends StatelessWidget {
  const InstitutionIllustration({super.key});
  @override
  Widget build(BuildContext context) => const ExcludeSemantics(
    child: CustomPaint(painter: _InstitutionPainter(), size: Size(340, 220)),
  );
}

class _InstitutionPainter extends CustomPainter {
  const _InstitutionPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final scale = (size.width / 340).clamp(0.0, size.height / 220);
    canvas.save();
    canvas.translate(
      (size.width - 340 * scale) / 2,
      (size.height - 220 * scale) / 2,
    );
    canvas.scale(scale);
    final paint = Paint();
    void oval(Rect rect, Color color) =>
        canvas.drawOval(rect, paint..color = color);
    void box(Rect rect, Color color, [double radius = 0]) => canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(radius)),
      paint..color = color,
    );
    void path(Path path, Color color) =>
        canvas.drawPath(path, paint..color = color);
    oval(const Rect.fromLTWH(24, 25, 292, 165), const Color(0xFFEEEAF8));
    oval(const Rect.fromLTWH(70, 5, 200, 180), const Color(0xFFF0EDF9));
    oval(const Rect.fromLTWH(8, 171, 324, 35), OnboardingPalette.paleTeal);
    box(const Rect.fromLTWH(65, 90, 210, 78), const Color(0xFFD2C7EB), 3);
    box(const Rect.fromLTWH(60, 85, 220, 12), const Color(0xFF9880C5), 2);
    for (final x in [75.0, 98.0, 230.0, 253.0]) {
      for (final y in [106.0, 132.0]) {
        box(Rect.fromLTWH(x, y, 12, 20), const Color(0xFFAB99D1), 2);
      }
    }
    box(const Rect.fromLTWH(125, 76, 90, 97), const Color(0xFFE8E0F4), 3);
    path(
      Path()
        ..moveTo(115, 78)
        ..lineTo(170, 48)
        ..lineTo(225, 78)
        ..close(),
      const Color(0xFF9279C2),
    );
    path(
      Path()
        ..moveTo(134, 75)
        ..lineTo(170, 56)
        ..lineTo(206, 75)
        ..close(),
      const Color(0xFFDAD0ED),
    );
    box(const Rect.fromLTWH(169, 25, 3, 27), const Color(0xFF9279C2));
    path(
      Path()
        ..moveTo(172, 25)
        ..cubicTo(180, 20, 187, 32, 194, 25)
        ..lineTo(194, 39)
        ..cubicTo(187, 44, 180, 32, 172, 39)
        ..close(),
      OnboardingPalette.purple,
    );
    for (final x in [136.0, 161.0, 186.0]) {
      box(Rect.fromLTWH(x, 92, 15, 58), Colors.white, 6);
      box(Rect.fromLTWH(x + 4, 96, 7, 42), const Color(0xFFB5A3D6), 3);
    }
    box(const Rect.fromLTWH(120, 166, 100, 7), const Color(0xFFB5A3D6), 2);
    for (final tree in [
      (30.0, 125.0, 1.0),
      (54.0, 151.0, .65),
      (307.0, 125.0, 1.0),
      (282.0, 150.0, .65),
    ]) {
      final (x, y, s) = tree;
      oval(
        Rect.fromCenter(center: Offset(x, y), width: 30 * s, height: 56 * s),
        const Color(0xFF34A7AD),
      );
      box(Rect.fromLTWH(x - 1.5, y + 2, 3, 60 * s), OnboardingPalette.teal, 1);
      canvas.drawLine(
        Offset(x, y + 23 * s),
        Offset(x - 10 * s, y + 12 * s),
        Paint()
          ..color = OnboardingPalette.teal
          ..strokeWidth = 2,
      );
      canvas.drawLine(
        Offset(x, y + 15 * s),
        Offset(x + 10 * s, y + 5 * s),
        Paint()
          ..color = OnboardingPalette.teal
          ..strokeWidth = 2,
      );
    }
    oval(const Rect.fromLTWH(116, 135, 28, 28), OnboardingPalette.purple);
    oval(const Rect.fromLTWH(160, 151, 26, 26), const Color(0xFF31A6AC));
    oval(const Rect.fromLTWH(211, 137, 27, 27), OnboardingPalette.orange);
    final purple = Path()
      ..moveTo(90, 210)
      ..cubicTo(105, 157, 128, 160, 153, 183)
      ..cubicTo(173, 203, 190, 214, 222, 210);
    final teal = Path()
      ..moveTo(125, 215)
      ..cubicTo(149, 185, 165, 193, 188, 205)
      ..cubicTo(202, 215, 215, 214, 233, 213);
    final orange = Path()
      ..moveTo(170, 193)
      ..cubicTo(195, 205, 213, 163, 235, 179)
      ..cubicTo(252, 188, 254, 198, 260, 211);
    for (final item in [
      (teal, OnboardingPalette.teal),
      (purple, OnboardingPalette.purple),
      (orange, OnboardingPalette.orange),
    ]) {
      canvas.drawPath(
        item.$1,
        Paint()
          ..color = item.$2
          ..style = PaintingStyle.stroke
          ..strokeWidth = 17
          ..strokeCap = StrokeCap.round,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _InstitutionPainter oldDelegate) => false;
}

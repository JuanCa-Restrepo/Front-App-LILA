import 'package:flutter/material.dart';

abstract final class OnboardingPalette {
  static const purple = Color(0xFF4E3D9B);
  static const teal = Color(0xFF008B7C);
  static const orange = Color(0xFFF29A01);
  static const ink = Color(0xFF4E4E4E);
  static const background = Color(0xFFF2F6F9);
  static const palePurple = Color(0xFFEAE4F7);
  static const paleTeal = Color(0xFFE1F3F2);
  static const paleOrange = Color(0xFFFFEED5);
}

class LilaWordmark extends StatelessWidget {
  const LilaWordmark({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'LILA',
      style: TextStyle(
        color: OnboardingPalette.purple,
        fontSize: 40,
        fontWeight: FontWeight.w900,
        letterSpacing: 2,
      ),
    );
  }
}

class OnboardingPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const OnboardingPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: OnboardingPalette.purple,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.arrow_forward_rounded, size: 22),
          ],
        ),
      ),
    );
  }
}

class OnboardingPageDots extends StatelessWidget {
  final int activeIndex;

  const OnboardingPageDots({super.key, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(2, (index) {
        final isActive = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: isActive ? 12 : 9,
          height: isActive ? 12 : 9,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isActive
                ? OnboardingPalette.purple
                : OnboardingPalette.palePurple,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}

class OnboardingBackground extends StatelessWidget {
  const OnboardingBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(painter: _OnboardingBackgroundPainter());
  }
}

class _OnboardingBackgroundPainter extends CustomPainter {
  const _OnboardingBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final waves = <(Color, double, double)>[
      (OnboardingPalette.palePurple, 0.00, 0.08),
      (OnboardingPalette.paleTeal, 0.06, 0.04),
      (OnboardingPalette.paleOrange, 0.13, 0.00),
    ];

    for (final (color, offset, lift) in waves) {
      final path = Path()
        ..moveTo(0, size.height * (0.88 + offset))
        ..cubicTo(
          size.width * 0.28,
          size.height * (0.80 + offset - lift),
          size.width * 0.66,
          size.height * (1.02 - lift),
          size.width,
          size.height * (0.84 + offset),
        )
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
      canvas.drawPath(path, Paint()..color = color.withValues(alpha: 0.68));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

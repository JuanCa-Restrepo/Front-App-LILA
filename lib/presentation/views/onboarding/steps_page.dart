import 'package:flutter/material.dart';

import 'onboarding_style.dart';

/// Segunda pantalla del onboarding: explica los 4 pasos del proceso.
class StepsPage extends StatelessWidget {
  final VoidCallback onStart;

  const StepsPage({super.key, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OnboardingPalette.background,
      body: Stack(
        children: [
          const Positioned.fill(child: OnboardingBackground()),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                        child: Column(
                          children: [
                            const LilaWordmark(),
                            const SizedBox(height: 24),
                            const Text(
                              '¿Cómo reportar\nun caso?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 32,
                                height: 1.05,
                                fontWeight: FontWeight.w800,
                                color: OnboardingPalette.ink,
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'El proceso consta de 4\npasos rápidos:',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 17,
                                height: 1.3,
                                color: OnboardingPalette.ink,
                              ),
                            ),
                            const SizedBox(height: 24),
                            const _StepsGrid(),
                            const SizedBox(height: 22),
                            const Text(
                              'Te guiaremos en cada uno para\nasegurar que la información sea precisa.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.4,
                                color: OnboardingPalette.ink,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
                      child: Column(
                        children: [
                          OnboardingPrimaryButton(
                            text: 'Comenzar',
                            onPressed: onStart,
                          ),
                          const SizedBox(height: 18),
                          const OnboardingPageDots(activeIndex: 1),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StepsGrid extends StatelessWidget {
  const _StepsGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 14) / 2;
        const items = [
          _StepData(
            number: 1,
            label: 'Perfil',
            icon: Icons.person_outline_rounded,
            color: OnboardingPalette.purple,
            surface: OnboardingPalette.palePurple,
          ),
          _StepData(
            number: 2,
            label: 'Detalles',
            icon: Icons.edit_note_rounded,
            color: OnboardingPalette.teal,
            surface: OnboardingPalette.paleTeal,
          ),
          _StepData(
            number: 3,
            label: 'Evidencias',
            icon: Icons.image_outlined,
            color: OnboardingPalette.orange,
            surface: OnboardingPalette.paleOrange,
          ),
          _StepData(
            number: 4,
            label: 'Confirmación',
            icon: Icons.check_circle_outline_rounded,
            color: OnboardingPalette.purple,
            surface: OnboardingPalette.palePurple,
          ),
        ];

        return Stack(
          children: [
            const Positioned.fill(
              child: CustomPaint(painter: _StepsRoutePainter()),
            ),
            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: items
                  .map(
                    (item) => SizedBox(
                      width: itemWidth,
                      height: itemWidth.clamp(152.0, 170.0),
                      child: _StepCard(data: item),
                    ),
                  )
                  .toList(),
            ),
          ],
        );
      },
    );
  }
}

class _StepCard extends StatelessWidget {
  final _StepData data;

  const _StepCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: OnboardingPalette.purple.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: data.color,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${data.number}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: data.surface,
                  shape: BoxShape.circle,
                ),
                child: Icon(data.icon, size: 40, color: data.color),
              ),
            ),
          ),
          Text(
            data.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: OnboardingPalette.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepsRoutePainter extends CustomPainter {
  const _StepsRoutePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = OnboardingPalette.teal.withValues(alpha: 0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(size.width * 0.18, size.height * 0.23)
      ..cubicTo(
        size.width * 0.52,
        size.height * 0.06,
        size.width * 0.88,
        size.height * 0.20,
        size.width * 0.82,
        size.height * 0.50,
      )
      ..cubicTo(
        size.width * 0.78,
        size.height * 0.80,
        size.width * 0.45,
        size.height * 0.95,
        size.width * 0.18,
        size.height * 0.76,
      );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StepData {
  final int number;
  final String label;
  final IconData icon;
  final Color color;
  final Color surface;

  const _StepData({
    required this.number,
    required this.label,
    required this.icon,
    required this.color,
    required this.surface,
  });
}

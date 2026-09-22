import 'package:flutter/material.dart';

import '../views/onboarding/onboarding_style.dart';

/// Burbuja visual de orientación hasta que exista su contenido.
class SideChat extends StatelessWidget {
  final double? top;
  final double? bottom;

  const SideChat({super.key, this.top, this.bottom});

  @override
  Widget build(BuildContext context) => Positioned(
    right: 16,
    top: top,
    bottom: bottom ?? (top == null ? 104 : null),
    child: Semantics(
      label: 'Orientación disponible próximamente',
      child: AbsorbPointer(
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: OnboardingPalette.teal,
            shape: BoxShape.circle,
            border: Border.all(color: OnboardingPalette.paleTeal, width: 2),
            boxShadow: [
              BoxShadow(
                color: OnboardingPalette.teal.withValues(alpha: 0.24),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(
            Icons.chat_bubble_outline_rounded,
            size: 26,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}

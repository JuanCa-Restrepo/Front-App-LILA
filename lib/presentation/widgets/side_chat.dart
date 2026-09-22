import 'package:flutter/material.dart';

import '../views/onboarding/onboarding_style.dart';

/// Control visual de orientación. Se expande para mostrar su disponibilidad.
class SideChat extends StatefulWidget {
  final double? top;
  final double? bottom;

  const SideChat({super.key, this.top, this.bottom});

  @override
  State<SideChat> createState() => _SideChatState();
}

class _SideChatState extends State<SideChat> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      top: widget.top,
      bottom: widget.bottom ?? (widget.top == null ? 104 : null),
      child: Semantics(
        button: true,
        label: _expanded
            ? 'Orientación disponible próximamente. Cerrar aviso'
            : 'Orientación. Mostrar disponibilidad',
        child: Material(
          color: _expanded ? Colors.white : OnboardingPalette.teal,
          elevation: 5,
          shadowColor: OnboardingPalette.teal.withValues(alpha: 0.24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: _expanded
                ? const BorderSide(color: OnboardingPalette.paleTeal, width: 2)
                : BorderSide.none,
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 24,
                      color: _expanded ? OnboardingPalette.teal : Colors.white,
                    ),
                    const SizedBox(width: 10),
                    if (_expanded)
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Orientación',
                            style: TextStyle(
                              color: OnboardingPalette.teal,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'Próximamente',
                            style: TextStyle(
                              color: OnboardingPalette.ink,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      )
                    else
                      const Text(
                        'Orientación',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    if (_expanded) ...[
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: OnboardingPalette.teal,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

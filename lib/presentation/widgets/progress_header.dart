import 'package:flutter/material.dart';

/// Cabecera estándar del flujo de reporte: botón "atrás" + barra de
/// progreso con `progress` entre 0.0 y 1.0.
class ProgressHeader extends StatelessWidget {
  final double progress;
  final VoidCallback? onBack;

  const ProgressHeader({
    super.key,
    required this.progress,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);
    return Row(
      children: [
        GestureDetector(
          onTap: onBack ?? () => Navigator.pop(context),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Container(
              height: 16,
              color: Colors.grey.shade300,
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: clamped,
                  child: Container(color: const Color(0xFFA89F9F)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

/// Segunda pantalla del onboarding: explica los 4 pasos del proceso.
class StepsPage extends StatelessWidget {
  final VoidCallback onStart;

  const StepsPage({
    super.key,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final horizontalPad = (w * 0.10).clamp(22.0, 40.0);
    final titleSize = (w * 0.085).clamp(24.0, 32.0);
    final subtitleSize = (w * 0.043).clamp(14.0, 17.0);
    final bodySize = (w * 0.038).clamp(12.0, 15.0);
    final circleSize = (w * 0.18).clamp(60.0, 76.0);
    final iconSize = (circleSize * 0.48).clamp(26.0, 36.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPad),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: h * 0.06),
                      Text(
                        '¿Cómo reportar\nun caso?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.w700,
                          height: 1.1,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: h * 0.035),
                      Text(
                        'El proceso consta de 4\npasos rápidos:',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: subtitleSize,
                          height: 1.3,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: h * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _StepItem(
                            icon: Icons.person_add_alt_1,
                            label: 'Perfil',
                            circleSize: circleSize,
                            iconSize: iconSize,
                          ),
                          _StepItem(
                            icon: Icons.edit_note,
                            label: 'Detalles',
                            circleSize: circleSize,
                            iconSize: iconSize,
                          ),
                        ],
                      ),
                      SizedBox(height: h * 0.035),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _StepItem(
                            icon: Icons.note_add,
                            label: 'Evidencias',
                            circleSize: circleSize,
                            iconSize: iconSize,
                          ),
                          _StepItem(
                            icon: Icons.check_circle_outline,
                            label: 'Confirmación',
                            circleSize: circleSize,
                            iconSize: iconSize,
                          ),
                        ],
                      ),
                      SizedBox(height: h * 0.045),
                      Text(
                        'Te guiaremos en cada uno para\nasegurar que la información sea precisa.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: bodySize,
                          height: 1.35,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: h * 0.04),
                      SizedBox(
                        width: (w * 0.42).clamp(150.0, 190.0),
                        height: (h * 0.06).clamp(42.0, 50.0),
                        child: ElevatedButton(
                          onPressed: onStart,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Comenzar',
                            style: TextStyle(
                              fontSize: (w * 0.04).clamp(14.0, 16.0),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: h * 0.09),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final double circleSize;
  final double iconSize;

  const _StepItem({
    required this.icon,
    required this.label,
    required this.circleSize,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: circleSize,
          height: circleSize,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: iconSize, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.black87),
        ),
      ],
    );
  }
}

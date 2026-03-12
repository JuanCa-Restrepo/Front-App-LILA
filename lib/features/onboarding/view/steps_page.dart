import 'package:flutter/material.dart';

/// ===========================================================
/// STEPS PAGE
/// Segunda pantalla del onboarding.
/// Explica los 4 pasos del proceso.
///
/// El botón "Comenzar" abre la HomePage.
/// ===========================================================
class StepsPage extends StatelessWidget {
  /// Función que llega desde OnboardingPage
  /// para abrir la pantalla principal.
  final VoidCallback onStart;

  const StepsPage({
    super.key,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    /// ---------------------------------------------------------
    /// OBTENEMOS EL TAMAÑO DE LA PANTALLA
    /// Esto nos permite hacer el diseño responsive.
    /// ---------------------------------------------------------
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    /// ---------------------------------------------------------
    /// MEDIDAS RESPONSIVE
    /// clamp() evita que queden exageradamente grandes o pequeños.
    /// ---------------------------------------------------------
    final horizontalPad = (w * 0.10).clamp(22.0, 40.0);
    final titleSize = (w * 0.085).clamp(24.0, 32.0);
    final subtitleSize = (w * 0.043).clamp(14.0, 17.0);
    final bodySize = (w * 0.038).clamp(12.0, 15.0);

    final circleSize = (w * 0.18).clamp(60.0, 76.0);
    final iconSize = (circleSize * 0.48).clamp(26.0, 36.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      /// -------------------------------------------------------
      /// SAFEAREA PARA EVITAR CHOQUES CON BARRAS DEL SISTEMA
      /// -------------------------------------------------------
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),

                /// -------------------------------------------------
                /// PADDING GENERAL HORIZONTAL
                /// -------------------------------------------------
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPad),

                  /// -------------------------------------------------
                  /// COLUMNA PRINCIPAL
                  /// mainAxisAlignment.center ayuda a que todo se vea
                  /// mejor distribuido verticalmente.
                  /// -------------------------------------------------
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: h * 0.06),

                      /// ---------------------------------------------
                      /// TÍTULO PRINCIPAL
                      /// ---------------------------------------------
                      Text(
                        "¿Cómo reportar\nun caso?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.w700,
                          height: 1.1,
                          color: Colors.black87,
                        ),
                      ),

                      SizedBox(height: h * 0.035),

                      /// ---------------------------------------------
                      /// SUBTÍTULO
                      /// ---------------------------------------------
                      Text(
                        "El proceso consta de 4\npasos rápidos:",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: subtitleSize,
                          height: 1.3,
                          color: Colors.black87,
                        ),
                      ),

                      SizedBox(height: h * 0.05),

                      /// ---------------------------------------------
                      /// GRID DE PASOS (2 ARRIBA / 2 ABAJO)
                      /// ---------------------------------------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          StepItem(
                            icon: Icons.person_add_alt_1,
                            label: "Perfil",
                            circleSize: circleSize,
                            iconSize: iconSize,
                          ),
                          StepItem(
                            icon: Icons.edit_note,
                            label: "Detalles",
                            circleSize: circleSize,
                            iconSize: iconSize,
                          ),
                        ],
                      ),

                      SizedBox(height: h * 0.035),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          StepItem(
                            icon: Icons.note_add,
                            label: "Evidencias",
                            circleSize: circleSize,
                            iconSize: iconSize,
                          ),
                          StepItem(
                            icon: Icons.check_circle_outline,
                            label: "Confirmación",
                            circleSize: circleSize,
                            iconSize: iconSize,
                          ),
                        ],
                      ),

                      SizedBox(height: h * 0.045),

                      /// ---------------------------------------------
                      /// TEXTO EXPLICATIVO
                      /// ---------------------------------------------
                      Text(
                        "Te guiaremos en cada uno para\nasegurar que la información sea precisa.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: bodySize,
                          height: 1.35,
                          color: Colors.black87,
                        ),
                      ),

                      SizedBox(height: h * 0.04),

                      /// ---------------------------------------------
                      /// BOTÓN COMENZAR
                      /// Conecta con la HomePage
                      /// ---------------------------------------------
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
                            "Comenzar",
                            style: TextStyle(
                              fontSize: (w * 0.04).clamp(14.0, 16.0),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      /// ---------------------------------------------
                      /// ESPACIO INFERIOR PEQUEÑO
                      /// Dejamos un margen pequeño para convivir
                      /// con los punticos del onboarding.
                      /// ---------------------------------------------
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

/// ===========================================================
/// STEP ITEM
/// Widget reutilizable para cada uno de los pasos del proceso.
/// ===========================================================
class StepItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final double circleSize;
  final double iconSize;

  const StepItem({
    super.key,
    required this.icon,
    required this.label,
    required this.circleSize,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// -----------------------------------------------------
        /// CÍRCULO DEL ÍCONO
        /// -----------------------------------------------------
        Container(
          width: circleSize,
          height: circleSize,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: iconSize,
            color: Colors.black87,
          ),
        ),

        const SizedBox(height: 8),

        /// -----------------------------------------------------
        /// TEXTO DEL PASO
        /// -----------------------------------------------------
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
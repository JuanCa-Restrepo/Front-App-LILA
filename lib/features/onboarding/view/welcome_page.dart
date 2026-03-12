import 'package:flutter/material.dart';

/// ===========================================================
/// WELCOME PAGE
/// Primera pantalla del onboarding.
/// Muestra el mensaje de bienvenida.
///
/// Al tocar la pantalla, pasa a la siguiente página.
/// ===========================================================
class WelcomePage extends StatelessWidget {
  /// Función que llega desde OnboardingPage
  /// para avanzar a la siguiente pantalla.
  final VoidCallback onNext;

  const WelcomePage({
    super.key,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,

      /// -------------------------------------------------------
      /// GestureDetector para que al tocar la pantalla avance
      /// -------------------------------------------------------
      body: GestureDetector(
        onTap: onNext,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// -------------------------------------------------
                /// Título principal
                /// -------------------------------------------------
                const Text(
                  "BIENVENIDXS",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 40),

                /// -------------------------------------------------
                /// Contenedor del logo
                /// Por ahora es placeholder visual.
                /// -------------------------------------------------
                Container(
                  height: 150,
                  width: 220,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Center(
                    child: Text(
                      "LOGO",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                /// -------------------------------------------------
                /// Texto principal
                /// -------------------------------------------------
                const Text(
                  "Tu voz es importante y está protegida.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),

                const SizedBox(height: 20),

                /// -------------------------------------------------
                /// Texto descriptivo
                /// -------------------------------------------------
                const Text(
                  "Esta plataforma te permite reportar situaciones de acoso de forma 100% anónima y segura.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),

                const SizedBox(height: 40),

                /// -------------------------------------------------
                /// Texto final
                /// -------------------------------------------------
                const Text(
                  "Te acompañaremos en el proceso.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
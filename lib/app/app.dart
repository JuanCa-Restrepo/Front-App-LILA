import 'package:flutter/material.dart';
import '../features/onboarding/view/onboarding_page.dart';

/// ===========================================================
/// APP
/// Configuración principal de la aplicación.
/// Aquí definimos el MaterialApp y la pantalla inicial.
/// ===========================================================
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      /// Quita la cinta roja de DEBUG
      debugShowCheckedModeBanner: false,

      /// Pantalla inicial de la app
      home: OnboardingPage(),
    );
  }
}
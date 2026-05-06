import 'package:flutter/material.dart';

/// Primera pantalla del onboarding. Al tocarla avanza al `StepsPage`.
class WelcomePage extends StatelessWidget {
  final VoidCallback onNext;

  const WelcomePage({
    super.key,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: GestureDetector(
        onTap: onNext,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'BIENVENIDXS',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  height: 150,
                  width: 220,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Center(
                    child: Text('LOGO', style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Tu voz es importante y está protegida.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Esta plataforma te permite reportar situaciones de acoso de forma 100% anónima y segura.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Te acompañaremos en el proceso.',
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

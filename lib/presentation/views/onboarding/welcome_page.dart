import 'package:flutter/material.dart';

import 'onboarding_style.dart';

/// Primera pantalla del onboarding.
class WelcomePage extends StatelessWidget {
  final VoidCallback onNext;

  const WelcomePage({super.key, required this.onNext});

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
                final illustrationSize = (constraints.maxWidth * 0.56).clamp(
                  175.0,
                  235.0,
                );

                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                        child: Column(
                          children: [
                            const LilaWordmark(),
                            const SizedBox(height: 16),
                            Container(
                              width: illustrationSize,
                              height: illustrationSize,
                              padding: EdgeInsets.all(illustrationSize * 0.08),
                              decoration: const BoxDecoration(
                                color: OnboardingPalette.paleTeal,
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                'assets/images/onboarding_support.png',
                                fit: BoxFit.contain,
                                semanticLabel:
                                    'Tres personas conectadas y acompañándose',
                              ),
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              'BIENVENIDXS',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                color: OnboardingPalette.ink,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Tu voz es importante y está protegida.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 21,
                                height: 1.2,
                                fontWeight: FontWeight.w700,
                                color: OnboardingPalette.ink,
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'Esta plataforma te permite reportar situaciones de acoso de forma 100% anónima y segura.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.4,
                                color: OnboardingPalette.ink,
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'Te acompañaremos en el proceso.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
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
                            text: 'Continuar',
                            onPressed: onNext,
                          ),
                          const SizedBox(height: 16),
                          const OnboardingPageDots(activeIndex: 0),
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

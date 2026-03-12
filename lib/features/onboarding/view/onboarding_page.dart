import 'package:flutter/material.dart';
import '../../home/view/home_page.dart';
import 'welcome_page.dart';
import 'steps_page.dart';

/// ===========================================================
/// ONBOARDING PAGE
/// Controla el flujo de las dos pantallas iniciales:
/// 1. WelcomePage
/// 2. StepsPage
///
/// También maneja:
/// - el deslizamiento entre páginas
/// - los indicadores inferiores
/// - la navegación hacia HomePage
/// ===========================================================
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  /// ---------------------------------------------------------
  /// Controlador del PageView
  /// Permite cambiar de pantalla programáticamente.
  /// ---------------------------------------------------------
  final PageController _pageController = PageController();

  /// Página actual del onboarding
  int currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// ---------------------------------------------------------
  /// Función para pasar a la siguiente página
  /// Se usará desde WelcomePage.
  /// ---------------------------------------------------------
  void nextPage() {
    if (currentPage < 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// ---------------------------------------------------------
  /// Función para ir a la pantalla principal con transición.
  ///
  /// En este caso usamos PageRouteBuilder para crear una
  /// animación personalizada:
  /// - la nueva pantalla aparece deslizándose desde la derecha
  /// - también se combina con un fade suave
  /// ---------------------------------------------------------
  void goToHome() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomePage(),
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) {
          /// ---------------------------------------------------
          /// ANIMACIÓN DE DESPLAZAMIENTO
          /// La pantalla entra desde la derecha hacia el centro.
          /// ---------------------------------------------------
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;

          final slideTween = Tween(
            begin: begin,
            end: end,
          ).chain(
            CurveTween(curve: Curves.easeInOutCubic),
          );

          /// ---------------------------------------------------
          /// ANIMACIÓN DE OPACIDAD
          /// La pantalla aparece gradualmente.
          /// ---------------------------------------------------
          final fadeTween = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).chain(
            CurveTween(curve: Curves.easeInOut),
          );

          return SlideTransition(
            position: animation.drive(slideTween),
            child: FadeTransition(
              opacity: animation.drive(fadeTween),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// -------------------------------------------------------
      /// Stack para poner el PageView y encima los indicadores
      /// -------------------------------------------------------
      body: Stack(
        children: [
          /// ---------------------------------------------------
          /// PageView con las 2 pantallas del onboarding
          /// ---------------------------------------------------
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            children: [
              /// Pantalla 1
              WelcomePage(onNext: nextPage),

              /// Pantalla 2
              StepsPage(onStart: goToHome),
            ],
          ),

          /// ---------------------------------------------------
          /// Indicadores inferiores (punticos)
          /// ---------------------------------------------------
          Positioned(
            bottom: 25,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDot(isActive: currentPage == 0),
                const SizedBox(width: 6),
                _buildDot(isActive: currentPage == 1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------------------------------------------------
  /// Widget para construir cada punto indicador
  /// ---------------------------------------------------------
  Widget _buildDot({required bool isActive}) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.deepPurple : Colors.grey.shade400,
        shape: BoxShape.circle,
      ),
    );
  }
}
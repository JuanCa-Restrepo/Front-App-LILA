import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/auth_viewmodel.dart';
import '../onboarding/onboarding_page.dart';

/// Pantalla de arranque: ejecuta el registro silencioso del dispositivo
/// (`AuthViewModel.initialize()`) y luego navega al onboarding.
///
/// Si el dispositivo ya tiene `idUsuario` cacheado, la transición es
/// prácticamente instantánea.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    final auth = context.read<AuthViewModel>();
    final ok = await auth.initialize();
    if (!mounted) return;
    if (ok) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingPage()),
      );
    }
    // Si falla, dejamos que la UI muestre el error y un botón de reintento.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Consumer<AuthViewModel>(
          builder: (context, vm, _) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'LILA',
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 28),
                    if (vm.errorMessage == null) ...[
                      const CircularProgressIndicator(color: Colors.black87),
                      const SizedBox(height: 18),
                      const Text(
                        'Preparando tu espacio seguro...',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, color: Colors.black87),
                      ),
                    ] else ...[
                      Icon(
                        Icons.wifi_off_rounded,
                        size: 56,
                        color: Colors.red.shade400,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        vm.errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 22),
                      ElevatedButton(
                        onPressed: vm.isLoading ? null : _bootstrap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

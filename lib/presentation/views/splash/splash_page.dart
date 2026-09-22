import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/auth_viewmodel.dart';
import '../onboarding/onboarding_page.dart';

/// Inicializa silenciosamente al usuario antes de abrir el onboarding.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  static const _purple = Color(0xFF4E3D9B);

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6F9),
      body: Consumer<AuthViewModel>(
        builder: (context, vm, _) {
          return Center(
            child: Semantics(
              label: vm.errorMessage == null
                  ? 'Inicializando la aplicación'
                  : 'No fue posible iniciar. Toca para reintentar',
              button: vm.errorMessage != null,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: vm.errorMessage == null || vm.isLoading
                    ? const SizedBox.square(
                        dimension: 52,
                        child: CircularProgressIndicator(
                          color: _purple,
                          strokeWidth: 4.5,
                          strokeCap: StrokeCap.round,
                        ),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.cloud_off_rounded,
                            color: _purple,
                            size: 44,
                          ),
                          const SizedBox(height: 12),
                          Text(vm.errorMessage!, textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: _bootstrap,
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('Reintentar'),
                          ),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}

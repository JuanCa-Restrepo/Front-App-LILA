import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/case_status_viewmodel.dart';
import '../../viewmodels/report_case_viewmodel.dart';
import '../../widgets/app_bottom_bar.dart';
import '../../widgets/primary_action_button.dart';
import '../../widgets/side_chat.dart';
import '../case_status/state_report_page.dart';
import '../home/home_page.dart';

/// Pantalla de éxito tras `submit()`. Muestra el `codigoCaso` plano
/// generado por el backend para que el usuario lo guarde.
class ReportFinalPage extends StatelessWidget {
  const ReportFinalPage({super.key});

  Future<void> _openStatus(BuildContext context, String codigo) async {
    final caseStatus = context.read<CaseStatusViewModel>();
    final found = await caseStatus.lookUpByCode(codigo);
    if (!context.mounted) return;
    if (found) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const StateReportPage()),
      );
    } else if (caseStatus.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(caseStatus.errorMessage!)),
      );
    }
  }

  void _backToHome(BuildContext context) {
    // Limpiamos el flujo de reporte y volvemos al Home descartando la
    // pila completa, así no queda historial del wizard.
    context.read<ReportCaseViewModel>().reset();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final horizontalPadding = (w * 0.08).clamp(20.0, 34.0);
    final titleSize = (w * 0.05).clamp(18.0, 23.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Stack(
          children: [
            Consumer<ReportCaseViewModel>(
              builder: (_, vm, __) {
                final codigo = vm.generatedCodigoCaso ?? '#--';
                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding, 14, horizontalPadding, 150,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => _backToHome(context),
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.home_outlined,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Denuncia registrada con éxito',
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: (h * 0.045).clamp(16.0, 34.0)),
                      Center(
                        child: Icon(
                          Icons.verified_rounded,
                          size: (w * 0.27).clamp(88.0, 122.0),
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: (h * 0.025).clamp(10.0, 22.0)),
                      Center(
                        child: Text(
                          'Tu código único es:',
                          style: TextStyle(
                            fontSize: (w * 0.05).clamp(18.0, 24.0),
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _CopyableCode(code: codigo, screenWidth: w),
                      SizedBox(height: (h * 0.03).clamp(14.0, 26.0)),
                      _InfoCard(screenWidth: w),
                      SizedBox(height: (h * 0.06).clamp(28.0, 60.0)),
                      Center(
                        child: SizedBox(
                          width: (w * 0.5).clamp(180.0, 240.0),
                          child: PrimaryActionButton(
                            text: 'Ver estado',
                            onTap: () => _openStatus(context, codigo),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: TextButton(
                          onPressed: () => _backToHome(context),
                          child: const Text('Finalizar y volver al inicio'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const AppBottomBar(),
            const SideChat(),
          ],
        ),
      ),
    );
  }
}

class _CopyableCode extends StatelessWidget {
  final String code;
  final double screenWidth;

  const _CopyableCode({required this.code, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: code));
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Código copiado al portapapeles.'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              code,
              style: TextStyle(
                fontSize: (screenWidth * 0.096).clamp(36.0, 52.0),
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.copy_rounded, color: Colors.black87, size: 22),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final double screenWidth;

  const _InfoCard({required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Text(
        'Guarda este código temporal. Al ser un reporte anónimo, es la única forma de consultar el progreso de tu caso.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: (screenWidth * 0.037).clamp(13.0, 16.0),
          color: Colors.black87,
          height: 1.35,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

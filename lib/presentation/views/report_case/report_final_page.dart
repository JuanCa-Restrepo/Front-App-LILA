import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/case_status_viewmodel.dart';
import '../../viewmodels/report_case_viewmodel.dart';
import '../case_status/state_report_page.dart';
import '../home/home_page.dart';
import '../onboarding/onboarding_style.dart';
import 'report_step_layout.dart';

/// Confirmación del flujo y acceso al código para consultar el caso.
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(caseStatus.errorMessage!)));
    }
  }

  void _backToHome(BuildContext context) {
    context.read<ReportCaseViewModel>().reset();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final report = context.watch<ReportCaseViewModel>();
    final codigo = report.generatedCodigoCaso;
    final isWitness = report.isWitness;
    final isDemo = codigo?.startsWith('LILA-DEMO-') ?? false;
    final canCheckStatus = codigo != null && !isDemo;

    return Scaffold(
      backgroundColor: OnboardingPalette.background,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: Center(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: FilledButton.icon(
                onPressed: canCheckStatus
                    ? () => _openStatus(context, codigo)
                    : () => _backToHome(context),
                icon: Icon(
                  canCheckStatus ? Icons.search_rounded : Icons.home_outlined,
                ),
                label: Text(
                  canCheckStatus ? 'Consultar estado' : 'Volver al inicio',
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: OnboardingPalette.purple,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 52),
                  textStyle: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxHeight < 700;
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    compact ? 12 : 20,
                    20,
                    compact ? 20 : 32,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const LilaWordmark(),
                          const Spacer(),
                          IconButton.filledTonal(
                            tooltip: 'Volver al inicio',
                            onPressed: () => _backToHome(context),
                            icon: const Icon(Icons.home_outlined),
                            style: IconButton.styleFrom(
                              backgroundColor: OnboardingPalette.palePurple,
                              foregroundColor: OnboardingPalette.purple,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: compact ? 18 : 28),
                      Text(
                        isWitness
                            ? 'TESTIGO · CONFIRMACIÓN'
                            : 'PASO 5 DE 5 · CONFIRMACIÓN',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: OnboardingPalette.purple,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.1,
                        ),
                      ),
                      SizedBox(height: compact ? 12 : 20),
                      Center(
                        child: Container(
                          width: compact ? 76 : 92,
                          height: compact ? 76 : 92,
                          decoration: const BoxDecoration(
                            color: OnboardingPalette.paleTeal,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isDemo
                                ? Icons.visibility_outlined
                                : Icons.verified_rounded,
                            color: OnboardingPalette.teal,
                            size: compact ? 42 : 52,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isWitness
                            ? 'Vista de testigo'
                            : isDemo
                            ? 'Vista de demostración'
                            : 'Reporte recibido',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF25204F),
                          fontSize: 27,
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isWitness
                            ? 'Este recorrido muestra cómo reportar como testigo. No se ha registrado un caso y el código es de demostración.'
                            : isDemo
                            ? 'Este recorrido es una vista previa. El código mostrado no corresponde a un caso registrado.'
                            : 'Guarda tu código para consultar el estado de tu reporte cuando lo necesites.',
                        textAlign: TextAlign.center,
                        style: reportSecondaryStyle,
                      ),
                      SizedBox(height: compact ? 20 : 28),
                      _CodeCard(code: codigo, isDemo: isDemo),
                      const SizedBox(height: 16),
                      _InfoCard(isDemo: isDemo),
                      if (canCheckStatus) ...[
                        const SizedBox(height: 14),
                        TextButton(
                          onPressed: () => _backToHome(context),
                          style: TextButton.styleFrom(
                            foregroundColor: OnboardingPalette.purple,
                          ),
                          child: const Text('Finalizar y volver al inicio'),
                        ),
                      ],
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

class _CodeCard extends StatelessWidget {
  final String? code;
  final bool isDemo;

  const _CodeCard({required this.code, required this.isDemo});

  Future<void> _copy(BuildContext context) async {
    final value = code;
    if (value == null) return;
    await Clipboard.setData(ClipboardData(text: value));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Código copiado al portapapeles.')),
    );
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: OnboardingPalette.palePurple, width: 2),
    ),
    child: Column(
      children: [
        Text(
          isDemo ? 'CÓDIGO DE DEMOSTRACIÓN' : 'CÓDIGO DEL CASO',
          style: const TextStyle(
            color: OnboardingPalette.purple,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 10),
        SelectableText(
          code ?? 'Código no disponible',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF25204F),
            fontSize: 27,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: code == null ? null : () => _copy(context),
          icon: const Icon(Icons.copy_rounded, size: 18),
          label: const Text('Copiar código'),
          style: OutlinedButton.styleFrom(
            foregroundColor: OnboardingPalette.purple,
            side: const BorderSide(color: OnboardingPalette.purple),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    ),
  );
}

class _InfoCard extends StatelessWidget {
  final bool isDemo;

  const _InfoCard({required this.isDemo});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: OnboardingPalette.paleTeal,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.lock_outline_rounded, color: OnboardingPalette.teal),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            isDemo
                ? 'El código de demostración sirve para explorar esta pantalla y no permite consultar un caso.'
                : 'Este código es la forma de consultar el progreso de tu reporte anónimo. Guárdalo en un lugar seguro.',
            style: const TextStyle(
              color: Color(0xFF22616B),
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ),
      ],
    ),
  );
}

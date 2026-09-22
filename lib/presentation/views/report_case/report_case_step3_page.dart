import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/report_case_viewmodel.dart';
import '../onboarding/onboarding_style.dart';
import 'report_case_step4_page.dart';
import 'report_step_layout.dart';
import 'institution_illustration.dart';

class ReportCaseStep3Page extends StatelessWidget {
  const ReportCaseStep3Page({super.key});

  void _goNext(BuildContext context) {
    if (context.read<ReportCaseViewModel>().pasoInstitucion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona Sí o No para continuar.')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ReportCaseStep4Page()),
    );
  }

  @override
  Widget build(BuildContext context) => ReportStepLayout(
    step: 3,
    section: 'Contexto',
    title: '¿Ocurrió en una institución educativa?',
    onNext: () => _goNext(context),
    onHelp: () => showReportHelp(
      context,
      title: 'Contexto institucional',
      child: const Text(
        'Selecciona Sí si la situación ocurrió dentro de una institución educativa, o No si ocurrió en otro lugar. En el siguiente paso puedes explicar el contexto con tus propias palabras.',
        style: reportSecondaryStyle,
      ),
    ),
    contentBuilder: (compact) => Consumer<ReportCaseViewModel>(
      builder: (context, vm, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: compact ? 170 : 220,
            child: const InstitutionIllustration(),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ReportChoiceCard(
                  title: 'Sí',
                  icon: Icons.school_outlined,
                  color: OnboardingPalette.purple,
                  selected: vm.pasoInstitucion == true,
                  onTap: () => vm.setPasoInstitucion(true),
                  vertical: true,
                  compact: compact,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: ReportChoiceCard(
                  title: 'No',
                  icon: Icons.location_city_rounded,
                  color: const Color(0xFF62598F),
                  selected: vm.pasoInstitucion == false,
                  onTap: () => vm.setPasoInstitucion(false),
                  vertical: true,
                  compact: compact,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'Esta información ayuda a contextualizar tu reporte. Puedes cambiar tu respuesta antes de enviarlo.',
            style: reportSecondaryStyle,
          ),
        ],
      ),
    ),
  );
}

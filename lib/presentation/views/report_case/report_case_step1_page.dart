import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/report_case_viewmodel.dart';
import '../onboarding/onboarding_style.dart';
import 'report_case_step2_page.dart';
import 'report_step_layout.dart';

/// Paso 1: perfil básico de la persona afectada.
class ReportCaseStep1Page extends StatefulWidget {
  const ReportCaseStep1Page({super.key});

  @override
  State<ReportCaseStep1Page> createState() => _ReportCaseStep1PageState();
}

class _ReportCaseStep1PageState extends State<ReportCaseStep1Page> {
  late final TextEditingController _orientationController;

  @override
  void initState() {
    super.initState();
    _orientationController = TextEditingController(
      text: context.read<ReportCaseViewModel>().orientacionGenero ?? '',
    );
  }

  @override
  void dispose() {
    _orientationController.dispose();
    super.dispose();
  }

  void _goNext() {
    final report = context.read<ReportCaseViewModel>();
    if (report.sexoBiologico == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona el sexo biológico.')),
      );
      return;
    }
    report.setOrientacionGenero(_orientationController.text.trim());
    FocusScope.of(context).unfocus();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ReportCaseStep2Page()),
    );
  }

  void _showHelp() => showReportHelp(
    context,
    title: 'Información de la persona afectada',
    child: const Text(
      'Estos datos nos ayudan a orientar mejor el reporte. Puedes indicar la etapa de vida, el sexo biológico y la orientación sexual. La información se mantiene protegida durante el proceso.',
      style: reportSecondaryStyle,
    ),
  );

  @override
  Widget build(BuildContext context) => ReportStepLayout(
    step: 1,
    section: 'Perfil',
    title: 'Cuéntanos sobre la persona afectada',
    subtitle: 'Esta información nos ayuda a orientar mejor el caso.',
    onNext: _goNext,
    onHelp: _showHelp,
    contentBuilder: (compact) => Consumer<ReportCaseViewModel>(
      builder: (context, vm, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _FieldTitle(
            number: '1',
            text: '¿Quién es la persona afectada?',
          ),
          const SizedBox(height: 10),
          _PersonSelector(
            selected: vm.personType,
            onChanged: vm.setPersonType,
            compact: compact,
          ),
          const SizedBox(height: 18),
          const _FieldTitle(number: '2', text: 'Sexo biológico'),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: vm.sexoBiologico,
            isExpanded: true,
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: OnboardingPalette.purple,
            ),
            dropdownColor: Colors.white,
            style: const TextStyle(
              fontFamily: 'Roboto',
              color: Color(0xFF25204F),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            decoration: _fieldDecoration(
              hint: 'Seleccionar opción...',
              icon: Icons.wc_rounded,
            ),
            hint: const Text(
              'Seleccionar opción...',
              style: TextStyle(
                fontFamily: 'Roboto',
                color: Color(0xFF77758A),
                fontSize: 13,
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
              DropdownMenuItem(value: 'Femenino', child: Text('Femenino')),
              DropdownMenuItem(
                value: 'Intersexual',
                child: Text('Intersexual'),
              ),
            ],
            onChanged: vm.setSexoBiologico,
          ),
          const SizedBox(height: 18),
          const _FieldTitle(number: '3', text: 'Orientación sexual'),
          const SizedBox(height: 8),
          TextField(
            controller: _orientationController,
            textCapitalization: TextCapitalization.sentences,
            onChanged: vm.setOrientacionGenero,
            style: const TextStyle(color: Color(0xFF25204F), fontSize: 14),
            decoration: _fieldDecoration(
              hint: 'Escribe la orientación sexual',
              icon: Icons.favorite_border_rounded,
            ),
          ),
          const SizedBox(height: 14),
          const _PrivacyNote(),
        ],
      ),
    ),
  );
}

class _FieldTitle extends StatelessWidget {
  final String number;
  final String text;

  const _FieldTitle({required this.number, required this.text});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 27,
        height: 27,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: OnboardingPalette.palePurple,
          shape: BoxShape.circle,
        ),
        child: Text(
          number,
          style: const TextStyle(
            color: OnboardingPalette.purple,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      const SizedBox(width: 9),
      Expanded(
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF25204F),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ],
  );
}

class _PersonSelector extends StatelessWidget {
  final AffectedPersonType selected;
  final ValueChanged<AffectedPersonType> onChanged;
  final bool compact;

  const _PersonSelector({
    required this.selected,
    required this.onChanged,
    required this.compact,
  });

  static const _options = [
    (AffectedPersonType.ninioNinia, 'Niña/Niño', Icons.child_care_outlined),
    (
      AffectedPersonType.adolescente,
      'Adolescente',
      Icons.accessibility_new_outlined,
    ),
    (AffectedPersonType.adulto, 'Adulto', Icons.person_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (var index = 0; index < _options.length; index++) ...[
        if (index > 0) const SizedBox(width: 8),
        Expanded(
          child: ReportChoiceCard(
            title: _options[index].$2,
            icon: _options[index].$3,
            color: index == 1
                ? OnboardingPalette.orange
                : OnboardingPalette.purple,
            selected: selected == _options[index].$1,
            onTap: () => onChanged(_options[index].$1),
            vertical: true,
            compact: compact,
          ),
        ),
      ],
    ],
  );
}

InputDecoration _fieldDecoration({
  required String hint,
  required IconData icon,
}) => InputDecoration(
  hintText: hint,
  hintStyle: reportSecondaryStyle,
  prefixIcon: Icon(icon, color: OnboardingPalette.purple, size: 21),
  filled: true,
  fillColor: Colors.white,
  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: const BorderSide(color: Color(0xFFE0E2EA)),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: const BorderSide(color: Color(0xFFE0E2EA)),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: const BorderSide(color: OnboardingPalette.purple, width: 1.6),
  ),
);

class _PrivacyNote extends StatelessWidget {
  const _PrivacyNote();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: OnboardingPalette.paleTeal,
      borderRadius: BorderRadius.circular(14),
    ),
    child: const Row(
      children: [
        Icon(Icons.lock_outline_rounded, color: OnboardingPalette.teal),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            'Tu información estará protegida durante todo el proceso.',
            style: TextStyle(
              color: Color(0xFF22616B),
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ),
      ],
    ),
  );
}

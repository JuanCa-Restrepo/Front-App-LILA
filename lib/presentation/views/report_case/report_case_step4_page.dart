import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/report_case_viewmodel.dart';
import '../onboarding/onboarding_style.dart';
import 'report_case_step5_page.dart';
import 'report_step_layout.dart';

class ReportCaseStep4Page extends StatefulWidget {
  const ReportCaseStep4Page({super.key});
  @override
  State<ReportCaseStep4Page> createState() => _ReportCaseStep4PageState();
}

class _ReportCaseStep4PageState extends State<ReportCaseStep4Page> {
  late final TextEditingController _descController;
  String? _error;

  @override
  void initState() {
    super.initState();
    _descController = TextEditingController(
      text: context.read<ReportCaseViewModel>().descripcion,
    );
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  void _goNext() {
    final text = _descController.text.trim();
    if (text.length < 10) {
      setState(() => _error = 'Escribe al menos 10 caracteres para continuar.');
      return;
    }
    context.read<ReportCaseViewModel>().setDescripcion(text);
    FocusScope.of(context).unfocus();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ReportCaseStep5Page()),
    );
  }

  @override
  Widget build(BuildContext context) => ReportStepLayout(
    step: 4,
    section: 'Descripción',
    title: 'Te escuchamos',
    subtitle: 'Cuéntanos lo que pasó con tus propias palabras.',
    onNext: _goNext,
    onHelp: () => showReportHelp(
      context,
      title: 'Cuéntanos lo ocurrido',
      child: const Text(
        'Puedes describir qué ocurrió, cuándo y dónde, e incluir los detalles que consideres importantes. Necesitamos al menos 10 caracteres para continuar. Tu relato se conserva mientras avanzas o vuelves entre estos pasos.',
        style: reportSecondaryStyle,
      ),
    ),
    contentBuilder: (compact) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ReportNote(text: 'Puedes tomarte el tiempo que necesites.'),
        const SizedBox(height: 20),
        TextField(
          controller: _descController,
          minLines: compact ? 6 : 9,
          maxLines: compact ? 6 : 9,
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
          textAlignVertical: TextAlignVertical.top,
          cursorColor: OnboardingPalette.purple,
          onChanged: (value) {
            context.read<ReportCaseViewModel>().setDescripcion(value);
            if (_error != null) setState(() => _error = null);
          },
          style: const TextStyle(
            color: Color(0xFF25204F),
            fontSize: 14,
            height: 1.5,
          ),
          decoration: InputDecoration(
            labelText: 'Descripción del caso',
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelStyle: const TextStyle(
              color: OnboardingPalette.purple,
              fontWeight: FontWeight.w600,
            ),
            hintText: 'Puedes contar qué ocurrió, cuándo y dónde.',
            hintStyle: reportSecondaryStyle,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(16),
            errorText: _error,
            errorMaxLines: 2,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: OnboardingPalette.purple),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: OnboardingPalette.purple),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: OnboardingPalette.purple,
                width: 2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _descController,
          builder: (context, value, _) => Text(
            '${value.text.characters.length} caracteres',
            textAlign: TextAlign.right,
            style: reportSecondaryStyle.copyWith(fontSize: 11),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Incluye los detalles que consideres importantes.',
          style: reportSecondaryStyle,
        ),
      ],
    ),
  );
}

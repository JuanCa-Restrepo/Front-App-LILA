import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/report_case_viewmodel.dart';
import '../../viewmodels/tipo_acoso_viewmodel.dart';
import '../onboarding/onboarding_style.dart';
import 'report_case_step3_page.dart';
import 'report_step_layout.dart';

/// Keeps the backend catalog and IDs as the source of selectable situations.
class ReportCaseStep2Page extends StatefulWidget {
  const ReportCaseStep2Page({super.key});
  @override
  State<ReportCaseStep2Page> createState() => _ReportCaseStep2PageState();
}

class _ReportCaseStep2PageState extends State<ReportCaseStep2Page> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<TipoAcosoViewModel>().load();
    });
  }

  void _goNext() {
    final id = context.read<ReportCaseViewModel>().idTipoAcoso;
    if (!context.read<TipoAcosoViewModel>().items.any(
      (item) => item.idTipoAcoso == id,
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona el tipo de acoso.')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ReportCaseStep3Page()),
    );
  }

  void _showGuide() => showReportHelp(
    context,
    title: 'Guía de orientación',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Estas descripciones pueden ayudarte a elegir la situación que mejor se acerca a lo ocurrido.',
          style: reportSecondaryStyle,
        ),
        for (final name in [
          'Acoso verbal',
          'Acoso físico',
          'Acoso sexual',
          'Acoso digital',
        ]) ...[
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(
              color: OnboardingPalette.purple,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(_situationStyle(name).$3, style: reportSecondaryStyle),
        ],
        const SizedBox(height: 16),
        const Text(
          'Si ocurrieron varias situaciones, selecciona la más cercana y cuéntanos los demás detalles en la descripción.',
          style: reportSecondaryStyle,
        ),
      ],
    ),
  );

  /// Mapeo visual local para presentar cualquier elemento del catálogo.
  /// Los identificadores y nombres seleccionables siguen viniendo del backend.
  (IconData, Color, String) _situationStyle(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('verbal')) {
      return (
        Icons.record_voice_over_rounded,
        OnboardingPalette.purple,
        'Insultos, burlas, amenazas o comentarios que te hacen sentir mal.',
      );
    }
    if (lower.contains('físico') || lower.contains('fisico')) {
      return (
        Icons.personal_injury_outlined,
        const Color(0xFFD94755),
        'Empujones, golpes o cualquier contacto que te lastime o asuste.',
      );
    }
    if (lower.contains('sexual')) {
      return (
        Icons.block_rounded,
        const Color(0xFFB92F43),
        'Comentarios, gestos o contactos de tipo sexual que no consentiste.',
      );
    }
    if (lower.contains('digital')) {
      return (
        Icons.smartphone_rounded,
        OnboardingPalette.teal,
        'Mensajes, fotos o publicaciones en redes que te acosan o exponen.',
      );
    }
    return (
      Icons.help_outline_rounded,
      OnboardingPalette.teal,
      'Selecciona la opción más cercana y detalla lo ocurrido en la descripción.',
    );
  }

  @override
  Widget build(BuildContext context) => ReportStepLayout(
    step: 2,
    section: 'Situación',
    title: '¿Qué está pasando?',
    subtitle: 'Selecciona la opción que mejor describa la situación.',
    onNext: _goNext,
    onHelp: _showGuide,
    contentBuilder: (compact) => Column(
      children: [
        Consumer2<TipoAcosoViewModel, ReportCaseViewModel>(
          builder: (context, catalog, report, _) {
            if (catalog.isLoading && !catalog.isLoaded) {
              return const Padding(
                padding: EdgeInsets.all(32),
                child: Center(
                  child: CircularProgressIndicator(
                    color: OnboardingPalette.purple,
                  ),
                ),
              );
            }
            if (!catalog.isLoaded) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: OnboardingPalette.purple,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      catalog.errorMessage ??
                          'No hay tipos de situación disponibles en este momento.',
                      textAlign: TextAlign.center,
                      style: reportSecondaryStyle,
                    ),
                    TextButton(
                      onPressed: () => catalog.load(force: true),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            }
            return Column(
              children: [
                for (var i = 0; i < catalog.items.length; i++) ...[
                  if (i > 0) const SizedBox(height: 8),
                  ReportChoiceCard(
                    title: catalog.items[i].descripcion,
                    description: _situationStyle(
                      catalog.items[i].descripcion,
                    ).$3,
                    icon: _situationStyle(catalog.items[i].descripcion).$1,
                    color: _situationStyle(catalog.items[i].descripcion).$2,
                    selected:
                        report.idTipoAcoso == catalog.items[i].idTipoAcoso,
                    onTap: () =>
                        report.setIdTipoAcoso(catalog.items[i].idTipoAcoso),
                    compact: compact,
                  ),
                ],
              ],
            );
          },
        ),
        const SizedBox(height: 10),
        Material(
          color: OnboardingPalette.paleTeal,
          borderRadius: BorderRadius.circular(14),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: _showGuide,
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(
                    Icons.menu_book_rounded,
                    color: OnboardingPalette.teal,
                    size: 28,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '¿No sabes cuál elegir?',
                          style: TextStyle(
                            color: Color(0xFF22616B),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Ver guía de orientación',
                          style: TextStyle(
                            color: OnboardingPalette.teal,
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/tipo_acoso_model.dart';
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
            const AppBottomBar(),
            const SideChat(),
          ],
        ),
      ),
    );
  }
}

class _SituationDropdown extends StatelessWidget {
  final List<TipoAcosoModel> items;
  final int? selectedId;
  final ValueChanged<int?> onChanged;
  final double screenWidth;

  const _SituationDropdown({
    required this.items,
    required this.selectedId,
    required this.onChanged,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      initialValue: selectedId,
      isExpanded: true,
      itemHeight: 56,
      icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 34),
      dropdownColor: Colors.white,
      style: TextStyle(
        fontSize: (screenWidth * 0.038).clamp(13.0, 16.0),
        color: Colors.black87,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade300,
        contentPadding: const EdgeInsets.only(
          left: 18, right: 56, top: 16, bottom: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      hint: const Text(
        'Selecciona el tipo de acoso que estás reportando',
        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
      ),
      items: items
          .map(
            (t) => DropdownMenuItem(
              value: t.idTipoAcoso,
              child: Text(
                t.descripcion,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}

class _ErrorRetry extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorRetry({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black87),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: onRetry,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}

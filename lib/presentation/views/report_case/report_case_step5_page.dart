import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/report_case_viewmodel.dart';
import '../onboarding/onboarding_style.dart';
import 'report_final_page.dart';
import 'report_step_layout.dart';

/// Paso 5: prepara las evidencias; la carga ocurre al enviar el reporte.
class ReportCaseStep5Page extends StatelessWidget {
  const ReportCaseStep5Page({super.key});

  Future<void> _pickImage(BuildContext context) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null || !context.mounted) return;
    final lowerName = picked.name.toLowerCase();
    final supported =
        lowerName.endsWith('.jpg') ||
        lowerName.endsWith('.jpeg') ||
        lowerName.endsWith('.png');
    if (!supported) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una imagen JPG o PNG.')),
      );
      return;
    }
    const maxBytes = 10 * 1024 * 1024;
    if (await picked.length() > maxBytes) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La imagen no puede superar los 10 MB.')),
      );
      return;
    }
    if (!context.mounted) return;
    context.read<ReportCaseViewModel>().addEvidence(
      EvidenceDraft(
        localPath: picked.path,
        tipoArchivo: 'image',
        fileName: picked.name,
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    final vm = context.read<ReportCaseViewModel>();
    final ok = await vm.submit();
    if (!context.mounted) return;
    if (ok) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ReportFinalPage()),
      );
    } else if (vm.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(vm.errorMessage!)));
    }
  }

  @override
  Widget build(BuildContext context) => Consumer<ReportCaseViewModel>(
    builder: (context, vm, _) => ReportStepLayout(
      step: 5,
      section: 'Evidencias',
      title: 'Agrega tus evidencias',
      subtitle:
          'Puedes adjuntar imágenes que respalden tu reporte. Este paso es opcional.',
      actionLabel: 'Enviar reporte',
      actionLoading: vm.isLoading,
      onNext: () => _submit(context),
      onHelp: () => showReportHelp(
        context,
        title: 'Evidencias del reporte',
        child: const Text(
          'Puedes adjuntar imágenes JPG o PNG de hasta 10 MB. Revisa que no incluyan información que no deseas compartir. Si no tienes evidencias, puedes enviar el reporte sin archivos.',
          style: reportSecondaryStyle,
        ),
      ),
      contentBuilder: (compact) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ReportNote(
            text: vm.pendingEvidences.isEmpty
                ? 'Tu reporte puede enviarse aunque no adjuntes evidencias.'
                : '${vm.pendingEvidences.length} ${vm.pendingEvidences.length == 1 ? 'archivo seleccionado' : 'archivos seleccionados'}.',
          ),
          const SizedBox(height: 16),
          _EvidenceArea(
            height: compact ? 150 : 260,
            compact: compact,
            evidences: vm.pendingEvidences,
            onPickImage: () => _pickImage(context),
            onRemove: vm.removeEvidenceAt,
          ),
          const SizedBox(height: 10),
          const Text(
            'Formatos admitidos: JPG y PNG. Tamaño máximo: 10 MB.',
            textAlign: TextAlign.center,
            style: reportSecondaryStyle,
          ),
        ],
      ),
    ),
  );
}

class _EvidenceArea extends StatelessWidget {
  final double height;
  final bool compact;
  final List<EvidenceDraft> evidences;
  final VoidCallback onPickImage;
  final void Function(int) onRemove;

  const _EvidenceArea({
    required this.height,
    required this.compact,
    required this.evidences,
    required this.onPickImage,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: const BorderSide(color: OnboardingPalette.purple, width: 1.4),
    ),
    clipBehavior: Clip.antiAlias,
    child: SizedBox(
      height: height,
      child: evidences.isEmpty
          ? InkWell(
              onTap: onPickImage,
              child: Padding(
                padding: EdgeInsets.all(compact ? 10 : 22),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: compact ? 25 : 34,
                      backgroundColor: OnboardingPalette.palePurple,
                      child: Icon(
                        Icons.add_photo_alternate_outlined,
                        color: OnboardingPalette.purple,
                        size: compact ? 27 : 36,
                      ),
                    ),
                    SizedBox(height: compact ? 8 : 14),
                    const Text(
                      'Seleccionar imágenes',
                      style: TextStyle(
                        color: Color(0xFF25204F),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (!compact) ...[
                      const SizedBox(height: 5),
                      const Text(
                        'Toca aquí para buscar archivos en tu dispositivo.',
                        textAlign: TextAlign.center,
                        style: reportSecondaryStyle,
                      ),
                    ],
                  ],
                ),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: evidences.length + 1,
              itemBuilder: (context, index) {
                if (index == evidences.length) {
                  return Material(
                    color: OnboardingPalette.palePurple,
                    borderRadius: BorderRadius.circular(14),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: onPickImage,
                      child: const Icon(
                        Icons.add_rounded,
                        size: 36,
                        color: OnboardingPalette.purple,
                      ),
                    ),
                  );
                }
                final evidence = evidences[index];
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: evidence.tipoArchivo == 'image'
                          ? Image.file(
                              File(evidence.localPath),
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => const ColoredBox(
                                color: OnboardingPalette.palePurple,
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  color: OnboardingPalette.purple,
                                ),
                              ),
                            )
                          : const ColoredBox(
                              color: OnboardingPalette.palePurple,
                              child: Icon(
                                Icons.insert_drive_file_outlined,
                                color: OnboardingPalette.purple,
                              ),
                            ),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: IconButton.filled(
                        tooltip: 'Quitar evidencia',
                        onPressed: () => onRemove(index),
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xCC25204F),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(30, 30),
                          padding: EdgeInsets.zero,
                        ),
                        icon: const Icon(Icons.close_rounded, size: 17),
                      ),
                    ),
                  ],
                );
              },
            ),
    ),
  );
}

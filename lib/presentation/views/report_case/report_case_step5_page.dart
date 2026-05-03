import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/report_case_viewmodel.dart';
import '../../widgets/app_bottom_bar.dart';
import '../../widgets/primary_action_button.dart';
import '../../widgets/progress_header.dart';
import '../../widgets/side_chat.dart';
import 'report_final_page.dart';

/// Paso 5 — Subida de evidencias. Aquí solo se ENLISTA cada archivo
/// elegido en `ReportCaseViewModel.pendingEvidences`. La subida real a
/// Drive ocurre dentro de `submit()` cuando el usuario confirma.
class ReportCaseStep5Page extends StatelessWidget {
  const ReportCaseStep5Page({super.key});

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final horizontalPadding = (w * 0.08).clamp(20.0, 34.0);
    final titleSize = (w * 0.052).clamp(19.0, 24.0);
    final descSize = (w * 0.041).clamp(14.0, 17.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding, 14, horizontalPadding, 150,
              ),
              child: Consumer<ReportCaseViewModel>(
                builder: (_, vm, __) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ProgressHeader(progress: 1.0),
                      const SizedBox(height: 18),
                      Text(
                        'Paso 5: Sube tus evidencias',
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: (h * 0.03).clamp(14.0, 28.0)),
                      Center(
                        child: Text(
                          'Puedes adjuntar archivos multimedia\nque respalden tu reporte.\nTu identidad sigue protegida',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: descSize,
                            height: 1.35,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: (h * 0.04).clamp(16.0, 30.0)),
                      _UploadArea(
                        height: (h * 0.34).clamp(220.0, 320.0),
                        evidences: vm.pendingEvidences,
                        onPickImage: () => _pickImage(context),
                        onRemove: vm.removeEvidenceAt,
                      ),
                      SizedBox(height: (h * 0.025).clamp(12.0, 22.0)),
                      Center(
                        child: Text(
                          'Solo se permiten imágenes (JPG, PNG) y audios (MP3, WAV). Tamaño máximo: 10MB.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: (w * 0.032).clamp(11.0, 13.0),
                            color: Colors.black87,
                            height: 1.35,
                          ),
                        ),
                      ),
                      SizedBox(height: (h * 0.06).clamp(28.0, 60.0)),
                      Center(
                        child: SizedBox(
                          width: (w * 0.5).clamp(180.0, 240.0),
                          child: PrimaryActionButton(
                            text: 'Enviar reporte',
                            onTap: vm.isLoading ? null : () => _submit(context),
                            isLoading: vm.isLoading,
                          ),
                        ),
                      ),
                    ],
                  );
                },
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

class _UploadArea extends StatelessWidget {
  final double height;
  final List<EvidenceDraft> evidences;
  final VoidCallback onPickImage;
  final void Function(int) onRemove;

  const _UploadArea({
    required this.height,
    required this.evidences,
    required this.onPickImage,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPickImage,
      child: Container(
        width: double.infinity,
        height: height,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(40),
        ),
        child: evidences.isEmpty
            ? Center(
                child: Container(
                  width: 108,
                  height: 108,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.upload_file_rounded,
                    size: 52,
                    color: Colors.black87,
                  ),
                ),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: evidences.length + 1,
                itemBuilder: (context, index) {
                  if (index == evidences.length) {
                    return GestureDetector(
                      onTap: onPickImage,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.add, size: 36),
                      ),
                    );
                  }
                  final ev = evidences[index];
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: ev.tipoArchivo == 'image'
                            ? Image.file(File(ev.localPath), fit: BoxFit.cover)
                            : Container(
                                color: Colors.grey.shade400,
                                alignment: Alignment.center,
                                child: const Icon(Icons.insert_drive_file),
                              ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => onRemove(index),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(2),
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}

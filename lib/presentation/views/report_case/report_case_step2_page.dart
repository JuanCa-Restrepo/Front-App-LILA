import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/tipo_acoso_model.dart';
import '../../viewmodels/report_case_viewmodel.dart';
import '../../viewmodels/tipo_acoso_viewmodel.dart';
import '../../widgets/app_bottom_bar.dart';
import '../../widgets/primary_action_button.dart';
import '../../widgets/progress_header.dart';
import '../../widgets/side_chat.dart';
import 'report_case_step3_page.dart';

/// Paso 2 — Selección del tipo de acoso desde el catálogo del backend
/// (`GET /tipos-acoso`).
class ReportCaseStep2Page extends StatefulWidget {
  const ReportCaseStep2Page({super.key});

  @override
  State<ReportCaseStep2Page> createState() => _ReportCaseStep2PageState();
}

class _ReportCaseStep2PageState extends State<ReportCaseStep2Page> {
  @override
  void initState() {
    super.initState();
    // Cargamos el catálogo si aún no está en memoria.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TipoAcosoViewModel>().load();
    });
  }

  void _goNext() {
    final reportVm = context.read<ReportCaseViewModel>();
    if (reportVm.idTipoAcoso == null) {
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final horizontalPadding = (w * 0.08).clamp(20.0, 34.0);
    final sectionGap = (h * 0.026).clamp(14.0, 24.0);
    final titleSize = (w * 0.043).clamp(15.0, 18.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding, 14, horizontalPadding, 150,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ProgressHeader(progress: 0.56),
                  const SizedBox(height: 14),
                  Text(
                    'Paso 2: Tipo de situación',
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: sectionGap * 1.2),
                  Consumer2<TipoAcosoViewModel, ReportCaseViewModel>(
                    builder: (_, catalog, report, __) {
                      if (catalog.isLoading && !catalog.isLoaded) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.black87,
                            ),
                          ),
                        );
                      }
                      if (catalog.errorMessage != null && !catalog.isLoaded) {
                        return _ErrorRetry(
                          message: catalog.errorMessage!,
                          onRetry: () => catalog.load(force: true),
                        );
                      }
                      return _SituationDropdown(
                        items: catalog.items,
                        selectedId: report.idTipoAcoso,
                        onChanged: report.setIdTipoAcoso,
                        screenWidth: w,
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      '¿No estás seguro? Conoce tus derechos y los tipos de delitos aquí',
                      style: TextStyle(
                        fontSize: (w * 0.034).clamp(12.0, 14.0),
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                  ),
                  SizedBox(height: (h * 0.42).clamp(210.0, 290.0)),
                  Center(
                    child: SizedBox(
                      width: (w * 0.42).clamp(160.0, 220.0),
                      child: PrimaryActionButton(
                        text: 'Siguiente paso',
                        onTap: _goNext,
                      ),
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

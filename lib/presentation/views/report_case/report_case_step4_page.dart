import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/report_case_viewmodel.dart';
import '../../widgets/app_bottom_bar.dart';
import '../../widgets/primary_action_button.dart';
import '../../widgets/progress_header.dart';
import '../../widgets/side_chat.dart';
import 'report_case_step5_page.dart';

/// Paso 4 — Descripción libre del caso. Reemplaza el `Text` placeholder
/// original por un `TextField` real conectado al ViewModel.
class ReportCaseStep4Page extends StatefulWidget {
  const ReportCaseStep4Page({super.key});

  @override
  State<ReportCaseStep4Page> createState() => _ReportCaseStep4PageState();
}

class _ReportCaseStep4PageState extends State<ReportCaseStep4Page> {
  late final TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    final vm = context.read<ReportCaseViewModel>();
    _descController = TextEditingController(text: vm.descripcion);
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  String get _dynamicTitle {
    final vm = context.read<ReportCaseViewModel>();
    return vm.pasoInstitucion == true
        ? 'Contexto institucional'
        : 'Contexto de la situación';
  }

  void _goNext() {
    final text = _descController.text.trim();
    if (text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La descripción debe tener al menos 10 caracteres.'),
        ),
      );
      return;
    }
    context.read<ReportCaseViewModel>().setDescripcion(text);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ReportCaseStep5Page()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final horizontalPadding = (w * 0.08).clamp(20.0, 34.0);
    final titleSize = (w * 0.052).clamp(19.0, 24.0);

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
                  const ProgressHeader(progress: 0.95),
                  const SizedBox(height: 18),
                  Text(
                    'Paso 4: $_dynamicTitle',
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: (h * 0.045).clamp(18.0, 36.0)),
                  Container(
                    width: double.infinity,
                    height: (h * 0.46).clamp(260.0, 420.0),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(36),
                    ),
                    child: TextField(
                      controller: _descController,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Describe tu caso...',
                        hintStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: (h * 0.19).clamp(90.0, 170.0)),
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/report_case_viewmodel.dart';
import '../../widgets/app_bottom_bar.dart';
import '../../widgets/choice_button.dart';
import '../../widgets/primary_action_button.dart';
import '../../widgets/progress_header.dart';
import '../../widgets/side_chat.dart';
import 'report_case_step4_page.dart';

/// Paso 3 — ¿Pasó dentro de la institución?
class ReportCaseStep3Page extends StatelessWidget {
  const ReportCaseStep3Page({super.key});

  void _goNext(BuildContext context) {
    final vm = context.read<ReportCaseViewModel>();
    if (vm.pasoInstitucion == null) {
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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final horizontalPadding = (w * 0.08).clamp(20.0, 34.0);
    final titleSize = (w * 0.043).clamp(15.0, 18.0);
    final questionSize = (w * 0.064).clamp(22.0, 28.0);

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
                      const ProgressHeader(progress: 0.78),
                      const SizedBox(height: 14),
                      Text(
                        'Paso 3: Contexto Institucional',
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: (h * 0.19).clamp(90.0, 190.0)),
                      Center(
                        child: Text(
                          '¿Paso dentro de la institución?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: questionSize,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      SizedBox(height: (h * 0.055).clamp(22.0, 48.0)),
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ChoiceButton(
                              text: 'Sí',
                              isSelected: vm.pasoInstitucion == true,
                              onTap: () => vm.setPasoInstitucion(true),
                            ),
                            const SizedBox(width: 18),
                            ChoiceButton(
                              text: 'No',
                              isSelected: vm.pasoInstitucion == false,
                              onTap: () => vm.setPasoInstitucion(false),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: (h * 0.38).clamp(160.0, 260.0)),
                      Center(
                        child: SizedBox(
                          width: (w * 0.42).clamp(160.0, 220.0),
                          child: PrimaryActionButton(
                            text: 'Siguiente paso',
                            onTap: () => _goNext(context),
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

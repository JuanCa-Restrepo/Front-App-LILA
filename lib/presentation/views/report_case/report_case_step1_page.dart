import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/report_case_viewmodel.dart';
import '../../widgets/app_bottom_bar.dart';
import '../../widgets/primary_action_button.dart';
import '../../widgets/progress_header.dart';
import '../../widgets/side_chat.dart';
import 'report_case_step2_page.dart';

/// Paso 1 — datos del afectado: tipo de persona, sexo biológico,
/// orientación sexual.
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
    final vm = context.read<ReportCaseViewModel>();
    _orientationController = TextEditingController(
      text: vm.orientacionGenero ?? '',
    );
  }

  @override
  void dispose() {
    _orientationController.dispose();
    super.dispose();
  }

  void _goNext() {
    final vm = context.read<ReportCaseViewModel>();
    vm.setOrientacionGenero(_orientationController.text.trim());
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ReportCaseStep2Page()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final horizontalPadding = (w * 0.08).clamp(20.0, 34.0);
    final sectionGap = (h * 0.025).clamp(14.0, 24.0);
    final titleSize = (w * 0.043).clamp(15.0, 18.0);
    final labelSize = (w * 0.038).clamp(13.0, 16.0);

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
                      const ProgressHeader(progress: 0.28),
                      const SizedBox(height: 14),
                      Text(
                        'Paso 1: Cuéntanos sobre el afectado',
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: sectionGap * 1.05),
                      _PersonSelector(
                        selected: vm.personType,
                        onChanged: vm.setPersonType,
                        screenWidth: w,
                      ),
                      SizedBox(height: sectionGap * 1.25),
                      Text(
                        'Sexo biológico',
                        style: TextStyle(
                          fontSize: labelSize,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _BiologicalSexDropdown(
                        value: vm.sexoBiologico,
                        onChanged: vm.setSexoBiologico,
                        screenWidth: w,
                      ),
                      SizedBox(height: sectionGap * 1.2),
                      Text(
                        'Orientación sexual',
                        style: TextStyle(
                          fontSize: labelSize,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _orientationController,
                        decoration: InputDecoration(
                          hintText: 'Escribe la orientación sexual',
                          hintStyle: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade300,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(height: sectionGap * 1.4),
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

class _PersonSelector extends StatelessWidget {
  final AffectedPersonType selected;
  final ValueChanged<AffectedPersonType> onChanged;
  final double screenWidth;

  const _PersonSelector({
    required this.selected,
    required this.onChanged,
    required this.screenWidth,
  });

  static const _options = <_PersonOption>[
    _PersonOption(AffectedPersonType.ninioNinia, 'Niña/Niño',
        Icons.child_care_outlined),
    _PersonOption(AffectedPersonType.adolescente, 'Adolescente',
        Icons.accessibility_new_outlined),
    _PersonOption(AffectedPersonType.adulto, 'Adulto',
        Icons.person_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _options.map((opt) {
        final isSelected = selected == opt.type;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => onChanged(opt.type),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.grey.shade300
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected
                        ? Colors.grey.shade400
                        : Colors.transparent,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      opt.icon,
                      size: (screenWidth * 0.09).clamp(28.0, 34.0),
                      color: Colors.black87,
                    ),
                    const SizedBox(height: 7),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        opt.label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: (screenWidth * 0.031).clamp(11.0, 13.0),
                          color: Colors.black87,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _PersonOption {
  final AffectedPersonType type;
  final String label;
  final IconData icon;
  const _PersonOption(this.type, this.label, this.icon);
}

class _BiologicalSexDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;
  final double screenWidth;

  const _BiologicalSexDropdown({
    required this.value,
    required this.onChanged,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18, vertical: 14,
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
        'Seleccionar opción...',
        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
      ),
      items: const [
        DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
        DropdownMenuItem(value: 'Femenino', child: Text('Femenino')),
        DropdownMenuItem(value: 'Intersexual', child: Text('Intersexual')),
      ],
      onChanged: onChanged,
    );
  }
}

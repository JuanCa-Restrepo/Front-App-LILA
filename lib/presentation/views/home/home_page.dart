import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/case_status_viewmodel.dart';
import '../../viewmodels/report_case_viewmodel.dart';
import '../../widgets/app_bottom_bar.dart';
import '../../widgets/side_chat.dart';
import '../case_status/state_report_page.dart';
import '../report_case/report_case_step1_page.dart';

/// Pantalla principal: botón de pánico, accesos a reporte y consulta de
/// estado por código.
///
/// Toda la lógica de "buscar caso por código" pasó al `CaseStatusViewModel`.
/// La View solo dispara `lookUpByCode` y reacciona al resultado.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _trackingCodeController = TextEditingController();

  double _panicProgress = 0.0;
  bool _showEmergencyOverlay = false;

  void _triggerEmergency() {
    setState(() {
      _showEmergencyOverlay = true;
      _panicProgress = 1.0;
    });
  }

  void _closeEmergency() {
    setState(() {
      _showEmergencyOverlay = false;
      _panicProgress = 0.0;
    });
  }

  Future<void> _onCheckStatus() async {
    final code = _trackingCodeController.text.trim();
    if (code.isEmpty) {
      _showSnack('Ingresa un código para consultar.');
      return;
    }

    final vm = context.read<CaseStatusViewModel>();
    final found = await vm.lookUpByCode(code);
    if (!mounted) return;

    if (found) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const StateReportPage()),
      );
      return;
    }

    if (vm.codeNotFound) {
      _showSnack('Código no registrado.');
    } else if (vm.errorMessage != null) {
      _showSnack(vm.errorMessage!);
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _openReportFlow() {
    // Limpiamos el flujo previo antes de iniciar uno nuevo.
    context.read<ReportCaseViewModel>().reset();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ReportCaseStep1Page()),
    );
  }

  @override
  void dispose() {
    _trackingCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final horizontalPadding = (w * 0.08).clamp(20.0, 34.0);
    final sectionGap = (h * 0.022).clamp(12.0, 22.0);
    final titleSize = (w * 0.048).clamp(16.0, 22.0);
    final bodySize = (w * 0.038).clamp(13.0, 16.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                16,
                horizontalPadding,
                120,
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: PopupMenuButton<String>(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      onSelected: (value) => _showSnack('Seleccionaste: $value'),
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'Guía', child: Text('Guía')),
                        PopupMenuItem(value: 'Opciones', child: Text('Opciones')),
                        PopupMenuItem(value: 'Información', child: Text('Información')),
                        PopupMenuItem(value: 'Ayuda', child: Text('Ayuda')),
                        PopupMenuItem(value: 'PQRS', child: Text('PQRS')),
                      ],
                      child: Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.menu, size: 22),
                      ),
                    ),
                  ),
                  SizedBox(height: sectionGap),
                  _buildPanicCard(),
                  SizedBox(height: sectionGap * 0.8),
                  Text(
                    'Desliza para activar el Botón de Pánico',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: bodySize,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: sectionGap * 1.5),
                  Text(
                    'Soy víctima',
                    style: TextStyle(fontSize: titleSize, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),
                  _MainButton(
                    text: 'Reportar un caso',
                    filled: true,
                    width: (w * 0.52).clamp(180.0, 250.0),
                    onTap: _openReportFlow,
                  ),
                  SizedBox(height: sectionGap * 1.1),
                  Text(
                    'Soy testigo',
                    style: TextStyle(fontSize: titleSize, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),
                  _MainButton(
                    text: 'Reportar una\nsituación',
                    filled: false,
                    width: (w * 0.58).clamp(200.0, 290.0),
                    onTap: () {},
                  ),
                  SizedBox(height: sectionGap * 1.4),
                  Text(
                    '¿Ya tienes un caso reportado?',
                    style: TextStyle(fontSize: bodySize, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    height: (h * 0.072).clamp(50.0, 60.0),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _trackingCodeController,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _onCheckStatus(),
                            decoration: InputDecoration(
                              hintText: 'Ingresa tu código o radicado anónimo',
                              hintStyle: TextStyle(
                                fontSize: (w * 0.04).clamp(13.0, 16.0),
                                color: Colors.black54,
                              ),
                              border: InputBorder.none,
                              isCollapsed: true,
                            ),
                          ),
                        ),
                        const Icon(Icons.search, size: 28),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Consumer<CaseStatusViewModel>(
                    builder: (_, vm, __) => _MainButton(
                      text: 'Consultar\nestado',
                      filled: false,
                      lightFilled: true,
                      width: (w * 0.44).clamp(160.0, 220.0),
                      onTap: vm.isLoading ? null : _onCheckStatus,
                      isLoading: vm.isLoading,
                    ),
                  ),
                ],
              ),
            ),
            const AppBottomBar(),
            const SideChat(top: 300),
            if (_showEmergencyOverlay) _buildEmergencyOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildPanicCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 22),
      decoration: BoxDecoration(
        color: const Color(0xFFE36A6A),
        borderRadius: BorderRadius.circular(34),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.notifications_none_rounded,
            size: 54,
            color: Colors.black87,
          ),
          const SizedBox(height: 18),
          _PanicSlider(
            value: _panicProgress,
            onChanged: (value) => setState(() => _panicProgress = value),
            onComplete: _triggerEmergency,
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.red.withValues(alpha: 0.92),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 90,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                const Text(
                  '¡EMERGENCIA!',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    'Se ha activado el modo de emergencia.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 34),
                GestureDetector(
                  onTap: _closeEmergency,
                  child: Container(
                    width: 92,
                    height: 92,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.18),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.call_end, size: 42, color: Colors.red),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Toca para desactivar',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MainButton extends StatelessWidget {
  final String text;
  final bool filled;
  final bool lightFilled;
  final double width;
  final VoidCallback? onTap;
  final bool isLoading;

  const _MainButton({
    required this.text,
    required this.filled,
    required this.width,
    required this.onTap,
    this.lightFilled = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = filled
        ? Colors.black87
        : lightFilled
            ? Colors.grey.shade300
            : Colors.grey.shade200;
    final fgColor = filled ? Colors.white : Colors.black87;

    return SizedBox(
      width: width,
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: filled ? null : Border.all(color: Colors.grey.shade400),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: Colors.black87,
                    ),
                  )
                : Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: fgColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _PanicSlider extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final VoidCallback onComplete;

  const _PanicSlider({
    required this.value,
    required this.onChanged,
    required this.onComplete,
  });

  @override
  State<_PanicSlider> createState() => _PanicSliderState();
}

class _PanicSliderState extends State<_PanicSlider> {
  double _localValue = 0.0;

  @override
  void initState() {
    super.initState();
    _localValue = widget.value;
  }

  @override
  void didUpdateWidget(covariant _PanicSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    _localValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const knobSize = 52.0;
        const trackHeight = 24.0;
        final maxDrag = constraints.maxWidth - knobSize;

        return SizedBox(
          height: knobSize,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                height: trackHeight,
                decoration: BoxDecoration(
                  color: const Color(0xFFB71C1C),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              Container(
                width: knobSize + (_localValue * maxDrag),
                height: trackHeight,
                decoration: BoxDecoration(
                  color: const Color(0xFFD32F2F),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              Positioned(
                left: _localValue * maxDrag,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _localValue += details.delta.dx / maxDrag;
                      _localValue = _localValue.clamp(0.0, 1.0);
                    });
                    widget.onChanged(_localValue);
                  },
                  onHorizontalDragEnd: (_) {
                    if (_localValue > 0.92) {
                      widget.onComplete();
                    } else {
                      setState(() => _localValue = 0.0);
                      widget.onChanged(_localValue);
                    }
                  },
                  child: Container(
                    width: knobSize,
                    height: knobSize,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

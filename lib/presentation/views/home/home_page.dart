import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/case_status_viewmodel.dart';
import '../../viewmodels/report_case_viewmodel.dart';
import '../../widgets/app_bottom_bar.dart';
import '../../widgets/side_chat.dart';
import '../case_status/state_report_page.dart';
import '../onboarding/onboarding_style.dart';
import '../report_case/report_case_step1_page.dart';

/// Pantalla principal: acceso a emergencia, reporte y consulta de estado.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _trackingCodeController = TextEditingController();
  double _panicProgress = 0;
  bool _showEmergencyOverlay = false;

  void _triggerEmergency() => setState(() {
    _showEmergencyOverlay = true;
    _panicProgress = 1;
  });

  void _closeEmergency() => setState(() {
    _showEmergencyOverlay = false;
    _panicProgress = 0;
  });

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
    } else if (vm.codeNotFound) {
      _showSnack('Código no registrado.');
    } else if (vm.errorMessage != null) {
      _showSnack(vm.errorMessage!);
    }
  }

  void _showSnack(String message) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message)));

  void _openReportFlow() {
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
    return Scaffold(
      backgroundColor: OnboardingPalette.background,
      bottomNavigationBar: MediaQuery.viewInsetsOf(context).bottom > 0
          ? null
          : const AppBottomBar.embedded(),
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned.fill(child: _HomeBackground()),
            LayoutBuilder(
              builder: (context, constraints) {
                final screenSize = MediaQuery.sizeOf(context);
                final useWideLayout =
                    screenSize.width >= 700 ||
                    screenSize.width > screenSize.height;
                if (useWideLayout) {
                  return _WideHomeLayout(
                    trackingCodeController: _trackingCodeController,
                    panicProgress: _panicProgress,
                    onPanicChanged: (value) =>
                        setState(() => _panicProgress = value),
                    onPanicComplete: _triggerEmergency,
                    onMenuSelected: _showSnack,
                    onOpenReport: _openReportFlow,
                    onCheckStatus: _onCheckStatus,
                  );
                }

                return _ResponsiveBody(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HomeHeader(onMenuSelected: _showSnack),
                      const SizedBox(height: 12),
                      const Text(
                        'Hola, estás en un\nespacio seguro',
                        style: TextStyle(
                          color: OnboardingPalette.ink,
                          fontSize: 27,
                          height: 1.08,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Elige cómo podemos acompañarte hoy.',
                        style: TextStyle(
                          color: OnboardingPalette.ink.withValues(alpha: 0.72),
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _EmergencyCard(
                        progress: _panicProgress,
                        onChanged: (value) =>
                            setState(() => _panicProgress = value),
                        onComplete: _triggerEmergency,
                      ),
                      const SizedBox(height: 16),
                      const _SectionTitle(
                        eyebrow: 'REPORTAR',
                        title: '¿Qué deseas hacer?',
                      ),
                      const SizedBox(height: 9),
                      Row(
                        children: [
                          Expanded(
                            child: _CompactReportCard(
                              icon: Icons.shield_outlined,
                              color: OnboardingPalette.purple,
                              surface: OnboardingPalette.palePurple,
                              title: 'Soy víctima',
                              description: 'Reportar un caso',
                              onTap: _openReportFlow,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _CompactReportCard(
                              icon: Icons.visibility_outlined,
                              color: OnboardingPalette.teal,
                              surface: OnboardingPalette.paleTeal,
                              title: 'Soy testigo',
                              description: 'Reportar una situación',
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const _SectionTitle(
                        eyebrow: 'SEGUIMIENTO',
                        title: '¿Ya tienes un caso reportado?',
                      ),
                      const SizedBox(height: 9),
                      _TrackingCard(
                        controller: _trackingCodeController,
                        onSubmitted: _onCheckStatus,
                      ),
                    ],
                  ),
                );
              },
            ),
            const SideChat(bottom: 18),
            if (_showEmergencyOverlay)
              _EmergencyOverlay(onClose: _closeEmergency),
          ],
        ),
      ),
    );
  }
}

class _WideHomeLayout extends StatelessWidget {
  final TextEditingController trackingCodeController;
  final double panicProgress;
  final ValueChanged<double> onPanicChanged;
  final VoidCallback onPanicComplete;
  final ValueChanged<String> onMenuSelected;
  final VoidCallback onOpenReport;
  final VoidCallback onCheckStatus;

  const _WideHomeLayout({
    required this.trackingCodeController,
    required this.panicProgress,
    required this.onPanicChanged,
    required this.onPanicComplete,
    required this.onMenuSelected,
    required this.onOpenReport,
    required this.onCheckStatus,
  });

  @override
  Widget build(BuildContext context) {
    final keyboardIsOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    final content = Padding(
      padding: const EdgeInsets.fromLTRB(28, 18, 28, 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HomeHeader(onMenuSelected: onMenuSelected),
                const SizedBox(height: 18),
                const Text(
                  'Hola, estás en un\nespacio seguro',
                  style: TextStyle(
                    color: OnboardingPalette.ink,
                    fontSize: 28,
                    height: 1.06,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Elige cómo podemos acompañarte hoy.',
                  style: TextStyle(
                    color: OnboardingPalette.ink.withValues(alpha: 0.72),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 18),
                _EmergencyCard(
                  progress: panicProgress,
                  onChanged: onPanicChanged,
                  onComplete: onPanicComplete,
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 11,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle(
                  eyebrow: 'REPORTAR',
                  title: '¿Qué deseas hacer?',
                ),
                const SizedBox(height: 10),
                _ReportActionCard(
                  icon: Icons.shield_outlined,
                  color: OnboardingPalette.purple,
                  surface: OnboardingPalette.palePurple,
                  title: 'Soy víctima',
                  description: 'Reportar un caso de forma segura',
                  onTap: onOpenReport,
                ),
                const SizedBox(height: 9),
                _ReportActionCard(
                  icon: Icons.visibility_outlined,
                  color: OnboardingPalette.teal,
                  surface: OnboardingPalette.paleTeal,
                  title: 'Soy testigo',
                  description: 'Reportar una situación que presencié',
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                const _SectionTitle(
                  eyebrow: 'SEGUIMIENTO',
                  title: '¿Ya tienes un caso reportado?',
                ),
                const SizedBox(height: 10),
                _TrackingCard(
                  controller: trackingCodeController,
                  onSubmitted: onCheckStatus,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: keyboardIsOpen
          ? const ClampingScrollPhysics()
          : const BouncingScrollPhysics(),
      child: content,
    );
  }
}

class _ResponsiveBody extends StatelessWidget {
  final Widget child;

  const _ResponsiveBody({required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = constraints.maxWidth < 360 ? 14.0 : 22.0;
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            12,
            horizontalPadding,
            16,
          ),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - 28,
              maxWidth: 680,
            ),
            child: child,
          ),
        );
      },
    );
  }
}

class _HomeHeader extends StatelessWidget {
  final ValueChanged<String> onMenuSelected;
  const _HomeHeader({required this.onMenuSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const LilaWordmark(),
        const Spacer(),
        PopupMenuButton<String>(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          onSelected: onMenuSelected,
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: OnboardingPalette.purple.withValues(alpha: 0.1),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.menu_rounded,
              color: OnboardingPalette.purple,
            ),
          ),
        ),
      ],
    );
  }
}

class _EmergencyCard extends StatelessWidget {
  final double progress;
  final ValueChanged<double> onChanged;
  final VoidCallback onComplete;
  const _EmergencyCard({
    required this.progress,
    required this.onChanged,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE96862), Color(0xFFD94755)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD94755).withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              _EmergencyIcon(),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¿Estás en peligro?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Activa una alerta de emergencia',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _PanicSlider(
            value: progress,
            onChanged: onChanged,
            onComplete: onComplete,
          ),
          const SizedBox(height: 6),
          const Center(
            child: Text(
              'Desliza para activar el Botón de Pánico',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmergencyIcon extends StatelessWidget {
  const _EmergencyIcon();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.notifications_active_outlined,
        color: Colors.white,
        size: 27,
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String eyebrow;
  final String title;
  const _SectionTitle({required this.eyebrow, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow,
          style: const TextStyle(
            color: OnboardingPalette.teal,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            color: OnboardingPalette.ink,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _CompactReportCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color surface;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _CompactReportCard({
    required this.icon,
    required this.color,
    required this.surface,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 23),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: OnboardingPalette.ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: OnboardingPalette.ink.withValues(alpha: 0.62),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReportActionCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color surface;
  final String title;
  final String description;
  final VoidCallback onTap;
  const _ReportActionCard({
    required this.icon,
    required this.color,
    required this.surface,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: color.withValues(alpha: 0.1)),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: OnboardingPalette.ink,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      description,
                      style: TextStyle(
                        color: OnboardingPalette.ink.withValues(alpha: 0.68),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrackingCard extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmitted;
  const _TrackingCard({required this.controller, required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: OnboardingPalette.purple.withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: controller,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => onSubmitted(),
            decoration: InputDecoration(
              hintText: 'Ingresa tu código o radicado anónimo',
              hintStyle: TextStyle(
                color: OnboardingPalette.ink.withValues(alpha: 0.5),
                fontSize: 13,
              ),
              prefixIcon: const Icon(
                Icons.tag_rounded,
                color: OnboardingPalette.purple,
              ),
              filled: true,
              fillColor: OnboardingPalette.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Consumer<CaseStatusViewModel>(
            builder: (context, vm, child) => SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: vm.isLoading ? null : onSubmitted,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: OnboardingPalette.purple,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: OnboardingPalette.palePurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: vm.isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Consultar estado',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
              ),
            ),
          ),
        ],
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
  double _localValue = 0;
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
        const knobSize = 48.0;
        final maxDrag = constraints.maxWidth - knobSize - 6;
        return Container(
          height: 54,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: const Color(0xFFB92F43).withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Stack(
            children: [
              const Center(
                child: Icon(
                  Icons.keyboard_double_arrow_right_rounded,
                  color: Colors.white54,
                  size: 30,
                ),
              ),
              Positioned(
                left: _localValue * maxDrag,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(
                      () => _localValue =
                          (_localValue + details.delta.dx / maxDrag).clamp(
                            0,
                            1,
                          ),
                    );
                    widget.onChanged(_localValue);
                  },
                  onHorizontalDragEnd: (_) {
                    if (_localValue > 0.92) {
                      widget.onComplete();
                    } else {
                      setState(() => _localValue = 0);
                      widget.onChanged(0);
                    }
                  },
                  child: Container(
                    width: knobSize,
                    height: knobSize,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.notifications_active_rounded,
                      color: Color(0xFFD94755),
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

class _EmergencyOverlay extends StatelessWidget {
  final VoidCallback onClose;
  const _EmergencyOverlay({required this.onClose});
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: const Color(0xFFE24951),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 112,
                  height: 112,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    size: 62,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  '¡EMERGENCIA!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Se ha activado el modo de emergencia.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: onClose,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFE24951),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 15,
                    ),
                  ),
                  icon: const Icon(Icons.call_end_rounded),
                  label: const Text('Toca para desactivar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeBackground extends StatelessWidget {
  const _HomeBackground();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -90,
          right: -80,
          child: Container(
            width: 230,
            height: 230,
            decoration: const BoxDecoration(
              color: OnboardingPalette.palePurple,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          top: 260,
          left: -90,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: OnboardingPalette.paleTeal.withValues(alpha: 0.7),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}

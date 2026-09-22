import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../data/models/caso_model.dart';
import '../../../data/models/evidencia_model.dart';
import '../../../data/models/responsable_model.dart';
import '../../viewmodels/case_status_viewmodel.dart';
import '../../widgets/app_bottom_bar.dart';
import '../home/home_page.dart';
import '../onboarding/onboarding_style.dart';

const _pageBackground = OnboardingPalette.background;
const _softSurface = Colors.white;
const _ink = OnboardingPalette.ink;

/// Estado del radicado: muestra el caso, su responsable y las evidencias
/// cargadas por [CaseStatusViewModel].
class StateReportPage extends StatelessWidget {
  const StateReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBackground,
      body: SafeArea(
        child: Stack(
          children: [
            Consumer<CaseStatusViewModel>(
              builder: (context, vm, child) {
                if (vm.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: _ink),
                  );
                }
                if (vm.errorMessage != null) {
                  return _CenteredMessage(
                    icon: Icons.cloud_off_rounded,
                    text: vm.errorMessage!,
                  );
                }

                final snapshot = vm.snapshot;
                if (snapshot == null) {
                  return const _CenteredMessage(
                    icon: Icons.search_off_rounded,
                    text: 'No hay caso cargado.',
                  );
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxHeight < 720;
                    final narrow = constraints.maxWidth < 420;
                    final horizontalPadding = constraints.maxWidth < 360
                        ? 20.0
                        : 32.0;

                    return SingleChildScrollView(
                      primary: false,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        14,
                        horizontalPadding,
                        142,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 520),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _Header(),
                              SizedBox(height: compact || narrow ? 30 : 40),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Estado del Radicado: ${snapshot.caso.codigoCaso}',
                                  maxLines: 1,
                                  style: const TextStyle(
                                    color: _ink,
                                    fontSize: 25,
                                    height: 1.15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              SizedBox(height: compact || narrow ? 32 : 46),
                              _StatusCard(estado: snapshot.caso.estado),
                              const SizedBox(height: 16),
                              _ResponsibleCard(
                                responsable: snapshot.responsable,
                              ),
                              SizedBox(height: compact || narrow ? 22 : 28),
                              _Timeline(caso: snapshot.caso),
                              SizedBox(height: compact || narrow ? 24 : 34),
                              _EvidencesSection(
                                evidencias: snapshot.evidencias,
                                sideOverflow: horizontalPadding,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const AppBottomBar(),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _HeaderButton(
          tooltip: 'Volver',
          icon: Icons.arrow_back_rounded,
          onPressed: () => Navigator.maybePop(context),
        ),
        _HeaderButton(
          tooltip: 'Ir al inicio',
          icon: Icons.home_outlined,
          onPressed: () {
            context.read<CaseStatusViewModel>().clear();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
              (route) => false,
            );
          },
        ),
      ],
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  const _HeaderButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 46,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(icon, size: 26),
        color: OnboardingPalette.purple,
        style: IconButton.styleFrom(
          backgroundColor: _softSurface,
          shadowColor: OnboardingPalette.purple.withValues(alpha: 0.12),
          elevation: 2,
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String estado;

  const _StatusCard({required this.estado});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('case-status-card'),
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 90),
      padding: const EdgeInsets.fromLTRB(18, 16, 16, 16),
      decoration: BoxDecoration(
        color: OnboardingPalette.palePurple,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: OnboardingPalette.purple.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                style: const TextStyle(color: _ink, fontSize: 16, height: 1.25),
                children: [
                  const TextSpan(
                    text: 'Estado: ',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  TextSpan(
                    text: _humanizeEstado(estado),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.history_rounded,
              size: 34,
              color: OnboardingPalette.purple,
            ),
          ),
        ],
      ),
    );
  }

  String _humanizeEstado(String raw) {
    switch (raw.toLowerCase()) {
      case 'pendiente':
        return 'Pendiente de revisión';
      case 'en_revision':
      case 'en revision':
      case 'en revisión':
        return 'En revisión';
      case 'asignado':
        return 'Asignado a profesional';
      case 'cerrado':
        return 'Cerrado';
      case 'inactivo':
        return 'Caso archivado';
      case 'demo':
        return 'Vista de demostración';
      default:
        return raw.isEmpty ? 'Sin estado' : raw;
    }
  }
}

class _ResponsibleCard extends StatelessWidget {
  final ResponsableModel? responsable;

  const _ResponsibleCard({required this.responsable});

  @override
  Widget build(BuildContext context) {
    final text = responsable == null
        ? 'Aún no se ha asignado un responsable a este caso.'
        : 'Profesional a cargo: ${responsable!.nombre}'
              '${responsable!.cargo != null ? ' (${responsable!.cargo})' : ''}';

    return Container(
      key: const Key('case-responsible-card'),
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 13, 10, 10),
      decoration: BoxDecoration(
        color: OnboardingPalette.paleTeal,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: OnboardingPalette.teal.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Responsable',
              style: TextStyle(
                color: _ink,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 11),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 68),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            decoration: BoxDecoration(
              color: _softSurface,
              borderRadius: BorderRadius.circular(21),
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: const TextStyle(
                color: _ink,
                fontSize: 14,
                height: 1.35,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  final CasoModel caso;

  const _Timeline({required this.caso});

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd/MM/yyyy HH:mm');
    final entries = <_TimelineEntry>[
      if (caso.fechaActualizacion != null)
        _TimelineEntry(
          when: fmt.format(caso.fechaActualizacion!),
          text: 'Última actualización del caso.',
        ),
      if (caso.fechaReporte != null)
        _TimelineEntry(
          when: fmt.format(caso.fechaReporte!),
          text: 'Denuncia recibida en el sistema.',
        ),
    ];

    if (entries.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: List.generate(entries.length, (index) {
          final entry = entries[index];
          final isLast = index == entries.length - 1;
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 18,
                  child: Column(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: OnboardingPalette.purple,
                          shape: BoxShape.circle,
                        ),
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 2,
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            color: OnboardingPalette.palePurple,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 28),
                    child: Text(
                      '${entry.when} — ${entry.text}',
                      style: const TextStyle(
                        color: OnboardingPalette.ink,
                        fontSize: 13,
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _TimelineEntry {
  final String when;
  final String text;

  const _TimelineEntry({required this.when, required this.text});
}

class _EvidencesSection extends StatelessWidget {
  final List<EvidenciaModel> evidencias;
  final double sideOverflow;

  const _EvidencesSection({
    required this.evidencias,
    required this.sideOverflow,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 14),
          child: evidencias.isEmpty
              ? Container(
                  key: const Key('case-empty-evidences'),
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 54),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: _softSurface,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: OnboardingPalette.purple.withValues(alpha: 0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Aún no se han adjuntado evidencias a este caso.',
                    style: TextStyle(
                      color: OnboardingPalette.ink,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : _EvidenceList(evidencias: evidencias),
        ),
        Positioned(right: -sideOverflow, top: -25, child: const _GuidanceTab()),
      ],
    );
  }
}

class _EvidenceList extends StatelessWidget {
  final List<EvidenciaModel> evidencias;

  const _EvidenceList({required this.evidencias});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Evidencias adjuntas',
          style: TextStyle(
            color: _ink,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 9),
        ...evidencias.map(
          (evidence) => Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 7),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: _softSurface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: OnboardingPalette.purple.withValues(alpha: 0.06),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(_iconFor(evidence.tipoArchivo), size: 22, color: _ink),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    evidence.urlArchivo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: _ink),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  IconData _iconFor(String? type) {
    switch (type) {
      case 'image':
        return Icons.image_outlined;
      case 'audio':
        return Icons.audiotrack_rounded;
      case 'video':
        return Icons.videocam_outlined;
      case 'pdf':
        return Icons.picture_as_pdf_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }
}

class _GuidanceTab extends StatelessWidget {
  const _GuidanceTab();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Orientación disponible próximamente',
      child: Container(
        key: const Key('case-guidance-tab'),
        width: 58,
        height: 112,
        decoration: const BoxDecoration(
          color: OnboardingPalette.paleTeal,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(26),
            bottomLeft: Radius.circular(26),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x18008B7C),
              blurRadius: 16,
              offset: Offset(-3, 5),
            ),
          ],
        ),
        child: const Icon(
          Icons.chat_bubble_outline_rounded,
          color: OnboardingPalette.teal,
          size: 26,
        ),
      ),
    );
  }
}

class _CenteredMessage extends StatelessWidget {
  final IconData icon;
  final String text;

  const _CenteredMessage({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 56, color: OnboardingPalette.purple),
            const SizedBox(height: 14),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: _ink),
            ),
          ],
        ),
      ),
    );
  }
}

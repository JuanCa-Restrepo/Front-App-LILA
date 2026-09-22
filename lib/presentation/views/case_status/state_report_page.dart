import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../data/models/caso_model.dart';
import '../../../data/models/evidencia_model.dart';
import '../../../data/models/responsable_model.dart';
import '../../viewmodels/case_status_viewmodel.dart';
import '../../widgets/app_bottom_bar.dart';
import '../../widgets/side_chat.dart';
import '../home/home_page.dart';

/// Estado del radicado: muestra el `CaseStatusSnapshot` cargado por el
/// `CaseStatusViewModel` (caso + responsable opcional + evidencias).
class StateReportPage extends StatelessWidget {
  const StateReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;
    final horizontalPadding = (w * 0.08).clamp(20.0, 34.0);
    final titleSize = (w * 0.06).clamp(22.0, 28.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Stack(
          children: [
            Consumer<CaseStatusViewModel>(
              builder: (_, vm, __) {
                if (vm.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.black87),
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
                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding, 14, horizontalPadding, 150,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Header(),
                      SizedBox(height: (h * 0.035).clamp(16.0, 32.0)),
                      Text(
                        'Estado del Radicado: ${snapshot.caso.codigoCaso}',
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: (h * 0.045).clamp(20.0, 40.0)),
                      _StatusCard(estado: snapshot.caso.estado),
                      const SizedBox(height: 14),
                      _ResponsibleCard(responsable: snapshot.responsable),
                      SizedBox(height: (h * 0.03).clamp(12.0, 24.0)),
                      _Timeline(caso: snapshot.caso, screenWidth: w),
                      SizedBox(height: (h * 0.035).clamp(14.0, 26.0)),
                      _EvidencesSection(evidencias: snapshot.evidencias),
                    ],
                  ),
                );
              },
            ),
            const AppBottomBar(),
            const SideChat(),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black87),
          ),
        ),
        GestureDetector(
          onTap: () {
            // Limpiamos el snapshot para que la próxima consulta arranque
            // desde un estado fresco.
            context.read<CaseStatusViewModel>().clear();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
              (route) => false,
            );
          },
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.home_outlined, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String estado;

  const _StatusCard({required this.estado});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87, fontSize: 16),
                children: [
                  const TextSpan(
                    text: 'Estado: ',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text: _humanizeEstado(estado),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.history, size: 30, color: Colors.black87),
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
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(14, 12, 14, 8),
            child: Text(
              'Responsable',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
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
  final double screenWidth;

  const _Timeline({required this.caso, required this.screenWidth});

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

    if (entries.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 22,
              child: Column(
                children: List.generate(entries.length, (i) {
                  final isLast = i == entries.length - 1;
                  return Column(
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        decoration: const BoxDecoration(
                          color: Colors.black87,
                          shape: BoxShape.circle,
                        ),
                      ),
                      if (!isLast)
                        Container(
                          width: 3,
                          height: 48,
                          color: Colors.grey.shade400,
                        ),
                    ],
                  );
                }),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: entries.map((e) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 28),
                    child: Text(
                      '${e.when} — ${e.text}',
                      style: TextStyle(
                        fontSize: (screenWidth * 0.035).clamp(12.0, 14.0),
                        color: Colors.black87,
                        height: 1.35,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
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

  const _EvidencesSection({required this.evidencias});

  @override
  Widget build(BuildContext context) {
    if (evidencias.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Text(
          'Aún no se han adjuntado evidencias a este caso.',
          style: TextStyle(color: Colors.black87, fontSize: 14),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Evidencias adjuntas',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        ...evidencias.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(_iconFor(e.tipoArchivo), size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        e.urlArchivo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  IconData _iconFor(String? tipo) {
    switch (tipo) {
      case 'image':
        return Icons.image_outlined;
      case 'audio':
        return Icons.audiotrack;
      case 'video':
        return Icons.videocam_outlined;
      case 'pdf':
        return Icons.picture_as_pdf_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
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
            Icon(icon, size: 56, color: Colors.black54),
            const SizedBox(height: 14),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../widgets/app_bottom_bar.dart';
import '../onboarding/onboarding_style.dart';

/// Reserves room for the media dock and scrolls only when content needs it.
class ReportStepLayout extends StatelessWidget {
  final int step;
  final String section;
  final String title;
  final String? subtitle;
  final Widget Function(bool compact) contentBuilder;
  final VoidCallback onNext;
  final VoidCallback onHelp;
  final String actionLabel;
  final bool actionLoading;

  const ReportStepLayout({
    super.key,
    required this.step,
    required this.section,
    required this.title,
    this.subtitle,
    required this.contentBuilder,
    required this.onNext,
    required this.onHelp,
    this.actionLabel = 'Continuar',
    this.actionLoading = false,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: OnboardingPalette.background,
    bottomNavigationBar: MediaQuery.viewInsetsOf(context).bottom > 0
        ? null
        : const AppBottomBar.embedded(),
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 700;
          // La altura disponible cambia al abrir el teclado. Mantener el
          // tamaño del formulario estable evita relayouts del campo activo.
          final compact = MediaQuery.sizeOf(context).height < 670;
          final intro = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: const Color(0xFF25204F),
                  fontSize: compact ? 24 : 28,
                  height: 1.15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(subtitle!, style: reportSecondaryStyle),
              ],
            ],
          );
          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1040),
              child: CustomScrollView(
                key: PageStorageKey<String>('report-step-$step'),
                primary: false,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      wide ? 28 : 16,
                      4,
                      wide ? 28 : 16,
                      4,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                tooltip: 'Volver',
                                onPressed: () => Navigator.maybePop(context),
                                icon: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 20,
                                ),
                                color: OnboardingPalette.purple,
                              ),
                              const Expanded(
                                child: Text(
                                  'Nuevo reporte',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF25204F),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: 'Ayuda para reportar',
                                onPressed: onHelp,
                                icon: const Icon(Icons.help_outline_rounded),
                                color: OnboardingPalette.purple,
                              ),
                            ],
                          ),
                          Semantics(
                            label: 'Paso $step de 5: $section',
                            child: ExcludeSemantics(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      for (
                                        var index = 1;
                                        index <= 5;
                                        index++
                                      ) ...[
                                        if (index > 1)
                                          Expanded(
                                            child: Container(
                                              height: 3,
                                              color: index <= step
                                                  ? OnboardingPalette.purple
                                                  : OnboardingPalette
                                                        .palePurple,
                                            ),
                                          ),
                                        Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: index <= step
                                                ? OnboardingPalette.purple
                                                : OnboardingPalette.palePurple,
                                            border: index == step
                                                ? Border.all(
                                                    color: Colors.white,
                                                    width: 2,
                                                  )
                                                : null,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Paso $step de 5 · $section',
                                    style: const TextStyle(
                                      color: OnboardingPalette.purple,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: compact ? 16 : 24),
                          if (wide)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(flex: 4, child: intro),
                                const SizedBox(width: 36),
                                Expanded(
                                  flex: 6,
                                  child: contentBuilder(compact),
                                ),
                              ],
                            )
                          else ...[
                            intro,
                            SizedBox(height: compact ? 14 : 20),
                            contentBuilder(compact),
                          ],
                          SizedBox(height: compact ? 20 : 28),
                          FilledButton(
                            onPressed: actionLoading ? null : onNext,
                            style: FilledButton.styleFrom(
                              backgroundColor: OnboardingPalette.purple,
                              foregroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: actionLoading
                                  ? const SizedBox.square(
                                      dimension: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.4,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      actionLabel,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.maybePop(context),
                            style: TextButton.styleFrom(
                              foregroundColor: OnboardingPalette.purple,
                            ),
                            child: const Text('Volver'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}

const reportSecondaryStyle = TextStyle(
  color: Color(0xFF77758A),
  fontSize: 13,
  height: 1.4,
);

class ReportChoiceCard extends StatelessWidget {
  final String title;
  final String? description;
  final IconData icon;
  final Color color;
  final bool selected;
  final bool vertical;
  final bool compact;
  final VoidCallback onTap;
  const ReportChoiceCard({
    super.key,
    required this.title,
    this.description,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
    this.vertical = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final indicator = Icon(
      selected ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
      color: selected ? OnboardingPalette.purple : const Color(0xFFBCBACA),
      size: 22,
    );
    return Semantics(
      selected: selected,
      inMutuallyExclusiveGroup: true,
      button: true,
      child: Material(
        color: selected ? const Color(0xFFF0ECFA) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: selected
                ? OnboardingPalette.purple
                : const Color(0xFFE0E2EA),
            width: selected ? 1.4 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(compact ? 12 : 16),
            child: vertical
                ? Column(
                    children: [
                      Align(alignment: Alignment.centerRight, child: indicator),
                      Icon(icon, color: color, size: compact ? 38 : 46),
                      const SizedBox(height: 6),
                      Text(
                        title,
                        style: const TextStyle(
                          color: Color(0xFF25204F),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Icon(icon, color: color, size: 32),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                color: Color(0xFF25204F),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (description != null) ...[
                              const SizedBox(height: 3),
                              Text(
                                description!,
                                style: reportSecondaryStyle.copyWith(
                                  fontSize: 11,
                                  height: 1.25,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      indicator,
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class ReportNote extends StatelessWidget {
  final String text;
  const ReportNote({super.key, required this.text});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: OnboardingPalette.paleTeal,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      children: [
        const Icon(
          Icons.favorite_border_rounded,
          color: OnboardingPalette.teal,
          size: 22,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF22616B),
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ),
      ],
    ),
  );
}

void showReportHelp(
  BuildContext context, {
  required String title,
  required Widget child,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: OnboardingPalette.background,
    builder: (context) => SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: OnboardingPalette.purple,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            child,
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Entendido'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

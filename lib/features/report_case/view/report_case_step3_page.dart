import 'package:flutter/material.dart';
import 'report_case_step4_page.dart';

/// ===========================================================
/// REPORT CASE STEP 3 PAGE
/// Pantalla visual para el tercer paso de reporte de caso.
/// Solo UI con estado local para selección visual.
/// ===========================================================
class ReportCaseStep3Page extends StatefulWidget {
  const ReportCaseStep3Page({super.key});

  @override
  State<ReportCaseStep3Page> createState() => _ReportCaseStep3PageState();
}

class _ReportCaseStep3PageState extends State<ReportCaseStep3Page> {
  bool isChatExpanded = false;
  int selectedBottomIndex = -1;
  bool? happenedInsideInstitution;

  void _toggleChat() {
    setState(() {
      isChatExpanded = !isChatExpanded;
    });
  }

  void _closeChat() {
    if (isChatExpanded) {
      setState(() {
        isChatExpanded = false;
      });
    }
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
                horizontalPadding,
                14,
                horizontalPadding,
                150,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(titleSize),
                  SizedBox(height: (h * 0.19).clamp(90.0, 190.0)),
                  Center(
                    child: Text(
                      "¿Paso dentro de la institución?",
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
                        _ChoiceButton(
                          text: "Sí",
                          isSelected: happenedInsideInstitution == true,
                          onTap: () {
                            setState(() {
                              happenedInsideInstitution = true;
                            });
                          },
                        ),
                        const SizedBox(width: 18),
                        _ChoiceButton(
                          text: "No",
                          isSelected: happenedInsideInstitution == false,
                          onTap: () {
                            setState(() {
                              happenedInsideInstitution = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: (h * 0.38).clamp(160.0, 260.0)),
                  Center(
                    child: SizedBox(
                      width: (w * 0.42).clamp(160.0, 220.0),
                      child: _PrimaryActionButton(
                        text: "Siguiente paso",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ReportCaseStep4Page(
                                isInstitutionContext:
                                    happenedInsideInstitution ?? true,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isChatExpanded)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _closeChat,
                ),
              ),
            _buildBottomBar(),
            _buildSideChat(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double titleSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  height: 16,
                  color: Colors.grey.shade300,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: 0.78,
                      child: Container(color: const Color(0xFFA89F9F)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          "Paso 3: Contexto Institucional",
          style: TextStyle(
            fontSize: titleSize,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    final items = [
      Icons.mic_none_rounded,
      Icons.videocam_outlined,
      Icons.camera_alt_outlined,
    ];

    return Positioned(
      left: 18,
      right: 18,
      bottom: 12,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(items.length, (index) {
              final isSelected = selectedBottomIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedBottomIndex = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.black87 : Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    items[index],
                    size: 32,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildSideChat() {
    return Positioned(
      right: 0,
      bottom: 104,
      child: GestureDetector(
        onTap: _toggleChat,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut,
          width: isChatExpanded ? 170 : 54,
          height: isChatExpanded ? 72 : 120,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(22),
              bottomLeft: const Radius.circular(22),
              topRight: Radius.circular(isChatExpanded ? 0 : 0),
              bottomRight: Radius.circular(isChatExpanded ? 0 : 0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: isChatExpanded
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.chat_bubble_outline,
                        size: 24,
                        color: Colors.black87,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "Abrir orientación",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _toggleChat,
                        child: const Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                )
              : const Center(
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Icon(
                      Icons.chat_bubble_outline,
                      size: 24,
                      color: Colors.black87,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _ChoiceButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? Colors.black87 : Colors.grey.shade300,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _PrimaryActionButton({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}

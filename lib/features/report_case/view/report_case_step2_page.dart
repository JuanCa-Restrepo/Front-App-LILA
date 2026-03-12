import 'package:flutter/material.dart';
import 'report_case_step3_page.dart';

/// ===========================================================
/// REPORT CASE STEP 2 PAGE
/// Pantalla visual para el segundo paso de reporte de caso.
/// Solo UI con estado local para simulación visual.
/// ===========================================================
class ReportCaseStep2Page extends StatefulWidget {
  const ReportCaseStep2Page({super.key});

  @override
  State<ReportCaseStep2Page> createState() => _ReportCaseStep2PageState();
}

class _ReportCaseStep2PageState extends State<ReportCaseStep2Page> {
  String? selectedSituationType;
  bool isChatExpanded = false;
  int selectedBottomIndex = -1;

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
    final sectionGap = (h * 0.026).clamp(14.0, 24.0);
    final titleSize = (w * 0.043).clamp(15.0, 18.0);

    return GestureDetector(
      onTap: _closeChat,
      child: Scaffold(
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
                    SizedBox(height: sectionGap * 1.2),
                    _buildSituationDropdown(w),
                    const SizedBox(height: 14),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "¿No estás seguro? Conoce tus derechos y los tipos de delitos aquí",
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
                        child: _PrimaryActionButton(
                          text: "Siguiente paso",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ReportCaseStep3Page(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _buildBottomBar(),
              _buildSideChat(),
            ],
          ),
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
                      widthFactor: 0.56,
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
          "Paso 2: Tipo de situación",
          style: TextStyle(
            fontSize: titleSize,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildSituationDropdown(double w) {
    return DropdownButtonFormField<String>(
      value: selectedSituationType,
      isExpanded: true,
      itemHeight: 56,
      icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 34),
      dropdownColor: Colors.white,
      style: TextStyle(
        fontSize: (w * 0.038).clamp(13.0, 16.0),
        color: Colors.black87,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade300,
        contentPadding: const EdgeInsets.only(
          left: 18,
          right: 56,
          top: 16,
          bottom: 16,
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
        "Selecciona el tipo de acoso que estás reportando",
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
      ),
      items: const [
        DropdownMenuItem(
          value: "Acoso sexual",
          child: Text(
            "Acoso sexual",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DropdownMenuItem(
          value: "Acoso académico",
          child: Text(
            "Acoso académico",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DropdownMenuItem(
          value: "Acoso por discriminación",
          child: Text(
            "Acoso por discriminación",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DropdownMenuItem(
          value: "Acoso psicológico",
          child: Text(
            "Acoso psicológico",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
      onChanged: (value) {
        setState(() {
          selectedSituationType = value;
        });
      },
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

import 'package:flutter/material.dart';
import 'state_report.dart';

/// ===========================================================
/// REPORT FINAL PAGE
/// Pantalla final visual de confirmación del reporte.
/// Solo UI, sin lógica real ni persistencia.
/// ===========================================================
class ReportFinalPage extends StatefulWidget {
  const ReportFinalPage({super.key});

  @override
  State<ReportFinalPage> createState() => _ReportFinalPageState();
}

class _ReportFinalPageState extends State<ReportFinalPage> {
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
    final titleSize = (w * 0.05).clamp(18.0, 23.0);

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
                    _buildHeader(),
                    const SizedBox(height: 18),
                    Text(
                      "Denuncia registrada con éxito",
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: (h * 0.045).clamp(16.0, 34.0)),
                    Center(
                      child: Icon(
                        Icons.verified_rounded,
                        size: (w * 0.27).clamp(88.0, 122.0),
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: (h * 0.025).clamp(10.0, 22.0)),
                    Center(
                      child: Text(
                        "Tu código único es:",
                        style: TextStyle(
                          fontSize: (w * 0.05).clamp(18.0, 24.0),
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        "#AC-9876",
                        style: TextStyle(
                          fontSize: (w * 0.096).clamp(36.0, 52.0),
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(height: (h * 0.03).clamp(14.0, 26.0)),
                    _buildInfoCard(w),
                    SizedBox(height: (h * 0.09).clamp(46.0, 90.0)),
                    Center(
                      child: SizedBox(
                        width: (w * 0.42).clamp(160.0, 220.0),
                        child: _PrimaryActionButton(
                          text: "Finalizado",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const StateReportPage(),
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

  Widget _buildHeader() {
    return Row(
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
                  widthFactor: 1.0,
                  child: Container(color: const Color(0xFFA89F9F)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(double w) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Text(
        "Guarda este código temporal. Al ser un reporte anónimo, es la única forma de consultar el progreso de tu caso.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: (w * 0.037).clamp(13.0, 16.0),
          color: Colors.black87,
          height: 1.35,
          fontWeight: FontWeight.w500,
        ),
      ),
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

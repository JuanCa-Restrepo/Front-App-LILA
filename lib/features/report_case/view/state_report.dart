import 'package:flutter/material.dart';
import '../../home/view/home_page.dart';

/// ===========================================================
/// STATE REPORT PAGE
/// Pantalla visual para consultar el estado del radicado.
/// Solo UI, sin lógica de backend ni carga dinámica.
/// ===========================================================
class StateReportPage extends StatefulWidget {
  const StateReportPage({super.key});

  @override
  State<StateReportPage> createState() => _StateReportPageState();
}

class _StateReportPageState extends State<StateReportPage> {
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
    final titleSize = (w * 0.06).clamp(22.0, 28.0);

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
                    SizedBox(height: (h * 0.035).clamp(16.0, 32.0)),
                    Text(
                      "Estado del Radicado: #AC-9876",
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: (h * 0.045).clamp(20.0, 40.0)),
                    _buildStatusCard(),
                    const SizedBox(height: 14),
                    _buildResponsibleCard(),
                    SizedBox(height: (h * 0.03).clamp(12.0, 24.0)),
                    _buildTimeline(w),
                    SizedBox(height: (h * 0.035).clamp(14.0, 26.0)),
                    _ActionButton(
                      text: "Subir documento de consentimiento\n(PDF/Imagen)",
                      onTap: () {},
                    ),
                    const SizedBox(height: 10),
                    _ActionButton(
                      text:
                          "Solicitar acompañamiento virtual\n(Videollamada / Chat)",
                      onTap: () {},
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
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black87,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
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
            child: const Icon(
              Icons.home_outlined,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard() {
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
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                ),
                children: const [
                  TextSpan(
                    text: "Estado: ",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text: "En revisión",
                    style: TextStyle(fontWeight: FontWeight.w500),
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
            child: const Icon(
              Icons.history,
              size: 30,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsibleCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
            child: Text(
              "Responsable",
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
            child: const Text(
              "Profesional a cargo: María Pérez (Orientadora)",
              style: TextStyle(
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

  Widget _buildTimeline(double w) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 22,
              child: Column(
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: const BoxDecoration(
                      color: Colors.black87,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: 3,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  Container(
                    width: 14,
                    height: 14,
                    decoration: const BoxDecoration(
                      color: Colors.black87,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 48),
                    child: Text(
                      "Hoy, 10:00 AM - Caso asignado al profesional a cargo.",
                      style: TextStyle(
                        fontSize: (w * 0.035).clamp(12.0, 14.0),
                        color: Colors.black87,
                        height: 1.35,
                      ),
                    ),
                  ),
                  Text(
                    "Ayer, 3:00 PM - Denuncia recibida en el sistema.",
                    style: TextStyle(
                      fontSize: (w * 0.035).clamp(12.0, 14.0),
                      color: Colors.black87,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
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

class _ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _ActionButton({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: const Color(0xFFAEADB2),
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                height: 1.1,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

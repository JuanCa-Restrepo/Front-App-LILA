import 'package:flutter/material.dart';
import '../../report_case/view/report_case_step1_page.dart';
import '../../report_case/view/state_report.dart';

/// ===========================================================
/// HOME PAGE
/// Pantalla principal de la app.
///
/// Incluye:
/// - botón de pánico con slider
/// - botones principales
/// - campo visual de consulta
/// - barra inferior interactiva
/// - chatbox lateral oculto
/// - overlay de emergencia
/// ===========================================================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const String _validTrackingCode = "#AC-9876";
  final TextEditingController _trackingCodeController = TextEditingController();

  /// ---------------------------------------------------------
  /// ESTADOS DE LA PANTALLA
  /// ---------------------------------------------------------

  // Progreso del slider del botón de pánico
  double panicProgress = 0.0;

  // Muestra u oculta la pantalla roja de emergencia
  bool showEmergencyOverlay = false;

  // Muestra u oculta el chat lateral
  bool isChatExpanded = false;

  // Índice seleccionado en la barra inferior
  int selectedBottomIndex = -1;

  /// ---------------------------------------------------------
  /// MÉTODOS AUXILIARES
  /// ---------------------------------------------------------

  // Abre o cierra el chatbox
  void _toggleChat() {
    setState(() {
      isChatExpanded = !isChatExpanded;
    });
  }

  // Cierra el chatbox al tocar fuera
  void _closeChat() {
    if (isChatExpanded) {
      setState(() {
        isChatExpanded = false;
      });
    }
  }

  // Activa la emergencia
  void _triggerEmergency() {
    setState(() {
      showEmergencyOverlay = true;
      panicProgress = 1.0;
    });
  }

  // Cierra la emergencia y reinicia el slider
  void _closeEmergency() {
    setState(() {
      showEmergencyOverlay = false;
      panicProgress = 0.0;
    });
  }

  void _onCheckStatus() {
    final typedCode = _trackingCodeController.text.trim();

    if (typedCode != _validTrackingCode) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Código no registrado"),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const StateReportPage(),
      ),
    );
  }

  @override
  void dispose() {
    _trackingCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// ---------------------------------------------------------
    /// MEDIDAS RESPONSIVE
    /// ---------------------------------------------------------
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final horizontalPadding = (w * 0.08).clamp(20.0, 34.0);
    final sectionGap = (h * 0.022).clamp(12.0, 22.0);
    final titleSize = (w * 0.048).clamp(16.0, 22.0);
    final bodySize = (w * 0.038).clamp(13.0, 16.0);

    return GestureDetector(
      onTap: _closeChat,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),

        /// -----------------------------------------------------
        /// CUERPO PRINCIPAL
        /// -----------------------------------------------------
        body: SafeArea(
          child: Stack(
            children: [
              /// -------------------------------------------------
              /// CONTENIDO SCROLLEABLE
              /// -------------------------------------------------
              SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  16,
                  horizontalPadding,
                  120,
                ),
                child: Column(
                  children: [
                    /// ---------------------------------------------
                    /// MENÚ HAMBURGUESA SUPERIOR DERECHO
                    /// ---------------------------------------------
                    Align(
                      alignment: Alignment.centerRight,
                      child: PopupMenuButton<String>(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        onSelected: (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Seleccionaste: $value'),
                            ),
                          );
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: 'Guía',
                            child: Text('Guía'),
                          ),
                          PopupMenuItem(
                            value: 'Opciones',
                            child: Text('Opciones'),
                          ),
                          PopupMenuItem(
                            value: 'Información',
                            child: Text('Información'),
                          ),
                          PopupMenuItem(
                            value: 'Ayuda',
                            child: Text('Ayuda'),
                          ),
                            PopupMenuItem(
                            value: 'PQRS',
                            child: Text('PQRS'),
                          ),
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

                    /// ---------------------------------------------
                    /// TARJETA DEL BOTÓN DE PÁNICO
                    /// ---------------------------------------------
                    _buildPanicCard(),

                    SizedBox(height: sectionGap * 0.8),

                    /// ---------------------------------------------
                    /// TEXTO EXPLICATIVO DEL SLIDER
                    /// ---------------------------------------------
                    Text(
                      "Desliza para activar el Botón de Pánico",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: bodySize,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),

                    SizedBox(height: sectionGap * 1.5),

                    /// ---------------------------------------------
                    /// SECCIÓN SOY VÍCTIMA
                    /// ---------------------------------------------
                    Text(
                      "Soy víctima",
                      style: TextStyle(
                        fontSize: titleSize,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 10),

                    _MainButton(
                      text: "Reportar un caso",
                      filled: true,
                      width: (w * 0.52).clamp(180.0, 250.0),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ReportCaseStep1Page(),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: sectionGap * 1.1),

                    /// ---------------------------------------------
                    /// SECCIÓN SOY TESTIGO
                    /// ---------------------------------------------
                    Text(
                      "Soy testigo",
                      style: TextStyle(
                        fontSize: titleSize,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 10),

                    _MainButton(
                      text: "Reportar una\nsituación",
                      filled: false,
                      width: (w * 0.58).clamp(200.0, 290.0),
                      onTap: () {},
                    ),

                    SizedBox(height: sectionGap * 1.4),

                    /// ---------------------------------------------
                    /// TEXTO DE CONSULTA
                    /// ---------------------------------------------
                    Text(
                      "¿Ya tienes un caso reportado?",
                      style: TextStyle(
                        fontSize: bodySize,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// ---------------------------------------------
                    /// CAMPO VISUAL DE BÚSQUEDA
                    /// ---------------------------------------------
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
                                hintText: "Ingresa tu código o radicado anónimo",
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

                    /// ---------------------------------------------
                    /// BOTÓN CONSULTAR ESTADO
                    /// ---------------------------------------------
                    _MainButton(
                      text: "Consultar\nestado",
                      filled: false,
                      lightFilled: true,
                      width: (w * 0.44).clamp(160.0, 220.0),
                      onTap: _onCheckStatus,
                    ),
                  ],
                ),
              ),

              /// -------------------------------------------------
              /// BARRA INFERIOR
              /// -------------------------------------------------
              _buildBottomBar(),

              /// -------------------------------------------------
              /// CHATBOX LATERAL
              /// -------------------------------------------------
              _buildSideChat(),

              /// -------------------------------------------------
              /// OVERLAY DE EMERGENCIA
              /// -------------------------------------------------
              if (showEmergencyOverlay) _buildEmergencyOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  /// =========================================================
  /// TARJETA SUPERIOR DEL BOTÓN DE PÁNICO
  /// =========================================================
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

          /// Slider gordito y con relleno visual
          _PanicSlider(
            value: panicProgress,
            onChanged: (value) {
              setState(() {
                panicProgress = value;
              });
            },
            onComplete: _triggerEmergency,
          ),
        ],
      ),
    );
  }

  /// =========================================================
  /// BARRA INFERIOR INTERACTIVA
  /// =========================================================
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
                    color:
                        isSelected ? Colors.black87 : Colors.transparent,
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

  /// =========================================================
  /// CHATBOX LATERAL ESCONDIDO
  /// =========================================================
  Widget _buildSideChat() {
    return Positioned(
      right: 0,
      top: 300,
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

          /// Estado expandido o colapsado
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

  /// =========================================================
  /// OVERLAY DE EMERGENCIA
  /// =========================================================
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
                  "¡EMERGENCIA!",
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
                    "Se ha activado el modo de emergencia.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 34),

                /// Botón para cerrar la emergencia
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
                    child: const Icon(
                      Icons.call_end,
                      size: 42,
                      color: Colors.red,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Toca para desactivar",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ===========================================================
/// BOTÓN PRINCIPAL REUTILIZABLE
/// ===========================================================
class _MainButton extends StatelessWidget {
  final String text;
  final bool filled;
  final bool lightFilled;
  final double width;
  final VoidCallback onTap;

  const _MainButton({
    required this.text,
    required this.filled,
    required this.width,
    required this.onTap,
    this.lightFilled = false,
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
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: filled
                  ? null
                  : Border.all(color: Colors.grey.shade400),
            ),
            child: Text(
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

/// ===========================================================
/// SLIDER DEL BOTÓN DE PÁNICO
/// Más grueso y con relleno visible.
/// ===========================================================
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
  double localValue = 0.0;

  @override
  void initState() {
    super.initState();
    localValue = widget.value;
  }

  @override
  void didUpdateWidget(covariant _PanicSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    localValue = widget.value;
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
              /// Fondo completo de la barra
              Container(
                height: trackHeight,
                decoration: BoxDecoration(
                  color: const Color(0xFFB71C1C),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),

              /// Relleno dinámico
              Container(
                width: knobSize + (localValue * maxDrag),
                height: trackHeight,
                decoration: BoxDecoration(
                  color: const Color(0xFFD32F2F),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),

              /// Knob deslizable
              Positioned(
                left: localValue * maxDrag,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      localValue += details.delta.dx / maxDrag;
                      localValue = localValue.clamp(0.0, 1.0);
                    });
                    widget.onChanged(localValue);
                  },
                  onHorizontalDragEnd: (_) {
                    if (localValue > 0.92) {
                      widget.onComplete();
                    } else {
                      setState(() {
                        localValue = 0.0;
                      });
                      widget.onChanged(localValue);
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

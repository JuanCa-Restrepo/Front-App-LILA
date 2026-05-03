import 'package:flutter/material.dart';

/// Burbuja lateral de "orientación". Se contrae en una pestañita y se
/// expande horizontalmente al tocarla.
///
/// Se usa como `Positioned` dentro de un `Stack`. Aceptamos `top` o
/// `bottom` para reproducir las dos posiciones que existen en las vistas.
class SideChat extends StatefulWidget {
  final double? top;
  final double? bottom;

  const SideChat({
    super.key,
    this.top,
    this.bottom,
  });

  @override
  State<SideChat> createState() => _SideChatState();
}

class _SideChatState extends State<SideChat> {
  bool _expanded = false;

  void _toggle() => setState(() => _expanded = !_expanded);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      top: widget.top,
      bottom: widget.bottom ?? (widget.top == null ? 104 : null),
      child: GestureDetector(
        onTap: _toggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut,
          width: _expanded ? 170 : 54,
          height: _expanded ? 72 : 120,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(22),
              bottomLeft: Radius.circular(22),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: _expanded ? _ExpandedContent(onClose: _toggle) : _CollapsedContent(),
        ),
      ),
    );
  }
}

class _CollapsedContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: RotatedBox(
        quarterTurns: 3,
        child: Icon(
          Icons.chat_bubble_outline,
          size: 24,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class _ExpandedContent extends StatelessWidget {
  final VoidCallback onClose;

  const _ExpandedContent({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
              'Abrir orientación',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          GestureDetector(
            onTap: onClose,
            child: const Icon(
              Icons.close,
              size: 18,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

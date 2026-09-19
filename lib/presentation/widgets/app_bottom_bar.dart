import 'package:flutter/material.dart';

/// Barra multimedia. Puede usarse flotante dentro de un `Stack` o integrada
/// en `Scaffold.bottomNavigationBar` para reservar su propio espacio.
class AppBottomBar extends StatefulWidget {
  final bool embedded;

  const AppBottomBar({super.key}) : embedded = false;

  const AppBottomBar.embedded({super.key}) : embedded = true;

  @override
  State<AppBottomBar> createState() => _AppBottomBarState();
}

class _AppBottomBarState extends State<AppBottomBar> {
  static const _items = [
    Icons.mic_none_rounded,
    Icons.videocam_outlined,
    Icons.camera_alt_outlined,
  ];

  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final dock = SafeArea(
      top: false,
      child: Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Container(
            margin: const EdgeInsets.fromLTRB(18, 0, 18, 10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.96),
              borderRadius: BorderRadius.circular(28),
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
              children: List.generate(_items.length, (index) {
                final isSelected = _selectedIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black87 : Colors.transparent,
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Icon(
                      _items[index],
                      size: 29,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );

    if (widget.embedded) return dock;

    return Positioned(left: 0, right: 0, bottom: 2, child: dock);
  }
}

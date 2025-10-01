import 'package:flutter/material.dart';

class ThemeOverlayAnimation extends StatelessWidget {
  final bool show;

  const ThemeOverlayAnimation({super.key, required this.show});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 280),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: show ? Curves.easeOut : Curves.easeIn,
        );
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1.0).animate(curved),
            child: child,
          ),
        );
      },
      child: show
          ? Container(
              key: const ValueKey('overlay'),
              color: Colors.black.withAlpha((0.45 * 255).round()),
            )
          : const SizedBox.shrink(),
    );
  }
}

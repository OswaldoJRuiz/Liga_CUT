import 'package:flutter/material.dart';
import 'package:liga/animations/theme_overlay_animation.dart';
import 'animations_kit_advanced.dart'; // Tu kit avanzado

// Presets de animaciones //

// Fade + Slide izquierda //
Widget presetFadeLeft(Widget child) {
  return FadeSlideAnimation(direction: SlideDirection.left, child: child);
}

// Fade + Slide derecha //
Widget presetFadeRight(Widget child) {
  return FadeSlideAnimation(direction: SlideDirection.right, child: child);
}

// Fade + Slide arriba //
Widget presetFadeUp(Widget child) {
  return FadeSlideAnimation(direction: SlideDirection.up, child: child);
}

// Fade + Slide abajo //
Widget presetFadeDown(Widget child) {
  return FadeSlideAnimation(direction: SlideDirection.down, child: child);
}

// Fade + Scale //
Widget presetFadeScale(Widget child) {
  return FadeScaleAnimation(beginScale: 0.8, endScale: 1.0, child: child);
}

// Blink //
Widget presetBlink(Widget child) {
  return BlinkAnimation(child: child);
}

// Theme Overlay //
Widget presetThemeOverlay(bool show) {
  return ThemeOverlayAnimation(show: show);
}

// Fade para Pantallas //
Widget presetFadeScreen(Widget child, {required int selectedIndex}) {
  return FadeScreenAnimation(
    child: KeyedSubtree(key: ValueKey<int>(selectedIndex), child: child),
  );
}

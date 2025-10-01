import 'package:flutter/material.dart';

// Can you meet me halfway? Right at the borderline Is where I'm gonna wait for you I'll be lookin' out night and day //
// Took my heart to the limit, and this is where I stay ♪♪♪ ( *︾▽︾) //

/// Widget para aplicar una animación de desvanecimiento (fade) a un hijo.
/// - Recibe un child (el widget al que se le aplicará la animación).
/// - Recibe una animation que controla la opacidad en tiempo real.
/// - Se usa para encapsular el FadeTransition y simplificar su uso en la app.
class FadeAnimation extends StatelessWidget {
  /// Widget hijo al que se le aplicará el fade.
  final Widget child;

  /// Animación que controla la opacidad (valor entre 0.0 y 1.0).
  final Animation<double> animation;

  const FadeAnimation({
    super.key,
    required this.child,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation, // La animación controla la transparencia
      child: child, // El widget que se mostrará con fade
    );
  }
}

import 'package:flutter/material.dart';

// Duración por defecto para todas las animaciones //
const Duration kDefaultAnimationDuration = Duration(milliseconds: 280);

/// ------------------------- \\\
///            Fade           \\\
/// ------------------------- \\\
class FadeAnimation extends StatelessWidget {
  final Widget child;
  final Duration duration;

  const FadeAnimation({
    super.key,
    required this.child,
    this.duration = kDefaultAnimationDuration,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: child,
    );
  }
}

/// ------------------------- \\\
///            Slide          \\\
/// ------------------------- \\\
enum SlideDirection { left, right, up, down }

class SlideAnimation extends StatelessWidget {
  final Widget child;
  final SlideDirection direction;
  final Duration duration;

  const SlideAnimation({
    super.key,
    required this.child,
    this.direction = SlideDirection.left,
    this.duration = kDefaultAnimationDuration,
  });

  @override
  Widget build(BuildContext context) {
    Offset beginOffset;
    switch (direction) {
      case SlideDirection.left:
        beginOffset = const Offset(-0.1, 0);
        break;
      case SlideDirection.right:
        beginOffset = const Offset(0.1, 0);
        break;
      case SlideDirection.up:
        beginOffset = const Offset(0, -0.1);
        break;
      case SlideDirection.down:
        beginOffset = const Offset(0, 0.1);
        break;
    }

    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (child, animation) {
        final offsetAnimation = Tween<Offset>(
          begin: beginOffset,
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
        return SlideTransition(position: offsetAnimation, child: child);
      },
      child: child,
    );
  }
}

/// ------------------------- \\\
///           Scale           \\\
/// ------------------------- \\\
class ScaleAnimation extends StatelessWidget {
  final Widget child;
  final double beginScale;
  final double endScale;
  final Duration duration;

  const ScaleAnimation({
    super.key,
    required this.child,
    this.beginScale = 0.9,
    this.endScale = 1.0,
    this.duration = kDefaultAnimationDuration,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (child, animation) {
        final scaleAnimation = Tween<double>(
          begin: beginScale,
          end: endScale,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
        return ScaleTransition(scale: scaleAnimation, child: child);
      },
      child: child,
    );
  }
}

/// ------------------------- \\\
///            Blink          \\\
/// ------------------------- \\\
class BlinkAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const BlinkAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
  });

  @override
  State<BlinkAnimation> createState() => _BlinkAnimationState();
}

class _BlinkAnimationState extends State<BlinkAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 1.0,
      end: 0.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _animation, child: widget.child);
  }
}

/// ------------------------- \\\
///  Combinaciones avanzadas  \\\
/// ------------------------- \\\
class FadeSlideAnimation extends StatelessWidget {
  final Widget child;
  final SlideDirection direction;
  final Duration duration;

  const FadeSlideAnimation({
    super.key,
    required this.child,
    this.direction = SlideDirection.left,
    this.duration = kDefaultAnimationDuration,
  });

  @override
  Widget build(BuildContext context) {
    Offset beginOffset;
    switch (direction) {
      case SlideDirection.left:
        beginOffset = const Offset(-0.1, 0);
        break;
      case SlideDirection.right:
        beginOffset = const Offset(0.1, 0);
        break;
      case SlideDirection.up:
        beginOffset = const Offset(0, -0.1);
        break;
      case SlideDirection.down:
        beginOffset = const Offset(0, 0.1);
        break;
    }

    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (child, animation) {
        final fadeAnim = animation;
        final slideAnim = Tween<Offset>(
          begin: beginOffset,
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
        return FadeTransition(
          opacity: fadeAnim,
          child: SlideTransition(position: slideAnim, child: child),
        );
      },
      child: child,
    );
  }
}

class FadeScaleAnimation extends StatelessWidget {
  final Widget child;
  final double beginScale;
  final double endScale;
  final Duration duration;

  const FadeScaleAnimation({
    super.key,
    required this.child,
    this.beginScale = 0.8,
    this.endScale = 1.0,
    this.duration = kDefaultAnimationDuration,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (child, animation) {
        final fadeAnim = animation;
        final scaleAnim = Tween<double>(
          begin: beginScale,
          end: endScale,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
        return FadeTransition(
          opacity: fadeAnim,
          child: ScaleTransition(scale: scaleAnim, child: child),
        );
      },
      child: child,
    );
  }
}

/// ------------------------- \\\
///      Fade (Pantallas)     \\\
/// ------------------------- \\\
class FadeScreenAnimation extends StatelessWidget {
  final Widget child;
  final Duration duration;

  const FadeScreenAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: KeyedSubtree(key: ValueKey(child.hashCode), child: child),
    );
  }
}

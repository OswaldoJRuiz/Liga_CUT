import 'dart:async';
import 'package:flutter/material.dart';

mixin SafeState<T extends StatefulWidget> on State<T> {
  final List<Timer> _timers = [];
  final List<StreamSubscription> _subscriptions = [];
  final List<AnimationController> _animations = [];

  /// Ejecuta un setState solo si el widget sigue montado
  void safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }

  /// Acceso seguro a Navigator
  NavigatorState? get safeNavigator => mounted ? Navigator.of(context) : null;

  /// Mostrar un SnackBar de forma segura
  void safeSnackBar(SnackBar snackBar) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  /// Registra un Timer para ser cancelado automáticamente
  void registerTimer(Timer timer) {
    _timers.add(timer);
  }

  /// Registra un StreamSubscription para cancelarlo automáticamente
  void registerStream(StreamSubscription subscription) {
    _subscriptions.add(subscription);
  }

  /// Registra un AnimationController para ser eliminado automáticamente
  void registerAnimation(AnimationController controller) {
    _animations.add(controller);
  }

  @override
  void dispose() {
    // Cancelar todos los timers
    for (var timer in _timers) {
      timer.cancel();
    }
    _timers.clear();

    // Cancelar todas las suscripciones
    for (var sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();

    // Disponer de todos los AnimationControllers
    for (var anim in _animations) {
      anim.dispose();
    }
    _animations.clear();

    super.dispose();
  }
}

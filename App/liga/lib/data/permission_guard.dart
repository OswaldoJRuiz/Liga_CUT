import 'package:flutter/material.dart';
import 'permission_helper.dart';
import 'package:liga/notifiers/permisos_notifier.dart';

class PermissionGuard extends StatefulWidget {
  final List<String> requeridos;
  final Widget child;
  final Widget? fallback;

  const PermissionGuard({
    super.key,
    required this.requeridos,
    required this.child,
    this.fallback,
  });

  @override
  State<PermissionGuard> createState() => _PermissionGuardState();
}

class _PermissionGuardState extends State<PermissionGuard> {
  @override
  void initState() {
    super.initState();
    // 🔹 Escucha cambios en PermisosNotifier
    PermisosNotifier.instance.addListener(_onPermisosChange);
  }

  @override
  void dispose() {
    PermisosNotifier.instance.removeListener(_onPermisosChange);
    super.dispose();
  }

  void _onPermisosChange() {
    if (mounted) setState(() {}); // Reconstruye al cambiar permisos
  }

  @override
  Widget build(BuildContext context) {
    final helper = permisosActuales(context);

    if (helper.alguno(widget.requeridos)) return widget.child;

    return widget.fallback ??
        const Center(child: Text("No tienes permisos suficientes"));
  }
}

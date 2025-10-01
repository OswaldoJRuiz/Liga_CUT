import 'package:flutter/material.dart';
import 'package:liga/notifiers/permisos_notifier.dart';

/// Helper para consultar permisos de forma más cómoda
class PermissionHelper {
  final List<String> permisos;

  PermissionHelper(this.permisos);

  bool tiene(String permiso) => permisos.contains(permiso);

  bool alguno(List<String> requeridos) =>
      permisos.any((p) => requeridos.contains(p));

  bool todos(List<String> requeridos) =>
      requeridos.every((r) => permisos.contains(r));
}

/// Getter que usa PermisosNotifier directamente
PermissionHelper permisosActuales(BuildContext context) {
  final permisos = PermisosNotifier.instance.permisos;
  return PermissionHelper(permisos);
}

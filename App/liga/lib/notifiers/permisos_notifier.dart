import 'package:flutter/material.dart';
import 'package:liga/services/usuario_permisos_service.dart';
import 'package:liga/managers/session_manager.dart';

class PermisosNotifier extends ChangeNotifier {
  static late PermisosNotifier instance;

  List<String> _permisos = [];
  List<String> get permisos => _permisos;

  static Future<void> init() async {
    instance = PermisosNotifier();

    final usuario = await SessionManager.getUser();
    if (usuario != null) {
      // Si hay usuario guardado, usamos sus permisos offline
      instance._permisos = usuario.permisosNombres;
    } else {
      instance._permisos = ["ver_liga"]; // Invitado por defecto
    }
  }

  Future<void> refreshPermisos(int userId) async {
    _permisos = await UsuarioPermisosService.obtenerPermisosUsuario(userId);
    notifyListeners();
  }

  Future<void> setInvitado() async {
    _permisos = ["ver_liga"];
    notifyListeners();
  }

  bool tienePermiso(String permiso) => _permisos.contains(permiso);
}

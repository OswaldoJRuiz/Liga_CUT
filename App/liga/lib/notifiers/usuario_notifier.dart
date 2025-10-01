import 'package:flutter/material.dart';
import 'package:liga/managers/session_manager.dart';
import 'package:liga/models/usuarios_model.dart';
import 'package:liga/notifiers/permisos_notifier.dart';
import 'package:liga/services/usuarios_servcie.dart';

class UsuarioNotifier extends ChangeNotifier {
  static late UsuarioNotifier instance;

  Usuario? _usuario;
  Usuario? get usuario => _usuario;

  static Future<void> init() async {
    instance = UsuarioNotifier();
    instance._usuario = await SessionManager.getUser();
  }

  Future<bool> login(String correo, String contrasena) async {
    final usuario = await UsuariosService.login(correo, contrasena);
    if (usuario != null) {
      _usuario = usuario;
      await SessionManager.setUser(usuario);
      notifyListeners();
      await PermisosNotifier.instance.refreshPermisos(_usuario!.id!);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _usuario = null;
    await SessionManager.clearUser();
    notifyListeners();
    await PermisosNotifier.instance.setInvitado();
  }

  Future<bool> cambiarContrasena(String actual, String nueva) async {
    if (_usuario == null) return false;
    final exito = await UsuariosService.cambiarContrasena(
      userId: _usuario!.id!,
      contrasenaActual: actual,
      contrasenaNueva: nueva,
    );
    return exito;
  }
}

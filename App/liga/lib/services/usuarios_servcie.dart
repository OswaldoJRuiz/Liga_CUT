import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuarios_model.dart';
import 'package:liga/services/mockusuarios.dart';
import 'api_config.dart';

class UsuariosService {
  /// Verifica si FastAPI está accesible
  static Future<void> verificarConexion() async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/ping');
      final response = await http.get(url).timeout(Duration(seconds: 3));
      if (response.statusCode == 200) {
        print('✅ FastAPI Usuarios accesible: ${response.body}');
      } else {
        print(
          '⚠️ FastAPI Usuarios respondió con status ${response.statusCode}',
        );
      }
    } catch (e) {
      print('❌ No se pudo conectar a FastAPI Usuarios: $e');
    }
  }

  static Future<Usuario?> login(String correo, String contrasena) async {
    if (ApiConfig.useMock) return MockUsuarios.login(correo, contrasena);

    await verificarConexion();

    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/login/');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'correo': correo, 'contrasena': contrasena}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        data['nombre_usuario'] ??= '';
        data['correo'] ??= '';
        data['permisos'] ??= [];
        print('✅ Login exitoso para $correo');
        return Usuario.fromJson(data);
      } else {
        print('⚠️ Error login: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Excepción login: $e');
      return null;
    }
  }

  static Future<Usuario?> registrarUsuario(Usuario usuario) async {
    if (ApiConfig.useMock) {
      return Usuario(
        id: MockUsuarios.usuarios.length + 1,
        nombreUsuario: usuario.nombreUsuario,
        correo: usuario.correo,
        contrasena: usuario.contrasena,
        permisos: [],
      );
    }

    await verificarConexion();

    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/usuarios/');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre_usuario': usuario.nombreUsuario,
          'correo': usuario.correo,
          'contrasena': usuario.contrasena,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        data['nombre_usuario'] ??= '';
        data['correo'] ??= '';
        data['permisos'] ??= [];
        print('✅ Usuario registrado: ${usuario.nombreUsuario}');
        return Usuario.fromJson(data);
      } else {
        print('⚠️ Error registrar usuario: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Excepción registrar usuario: $e');
      return null;
    }
  }

  static Future<bool> cambiarContrasena({
    required int userId,
    required String contrasenaActual,
    required String contrasenaNueva,
  }) async {
    if (ApiConfig.useMock) return true;

    await verificarConexion();

    try {
      final url = Uri.parse(
        '${ApiConfig.baseUrl}/usuarios/$userId/cambiar_contrasena/',
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contrasena_actual': contrasenaActual,
          'contrasena_nueva': contrasenaNueva,
        }),
      );
      if (response.statusCode == 200) {
        print('✅ Contraseña cambiada correctamente para usuario $userId');
        return true;
      } else {
        print('⚠️ Error cambiando contraseña: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Excepción cambiar contraseña: $e');
      return false;
    }
  }
}

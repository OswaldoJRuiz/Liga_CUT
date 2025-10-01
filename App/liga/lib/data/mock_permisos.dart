import 'dart:convert';
import 'package:http/http.dart' as http;

// 🔹 Mock de permisos
class MockPermisos {
  // Para cada usuario, una lista de nombres de permisos
  static final Map<int, List<String>> permisosPorUsuario = {
    1: ["gestionar_liga", "gestionar_equipo", "agregar_jugador"], // admin
    2: ["gestionar_equipo"], // capitán
    3: ["ver_liga"], // invitado o usuario de prueba
  };

  static Future<List<String>> obtenerPermisosUsuario(int usuarioId) async {
    await Future.delayed(const Duration(milliseconds: 300)); // simula delay
    return permisosPorUsuario[usuarioId] ?? ["ver_liga"];
  }

  static Future<bool> asignarPermiso({
    required int usuarioId,
    required String permisoNombre,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    permisosPorUsuario.putIfAbsent(usuarioId, () => []);
    permisosPorUsuario[usuarioId]!.add(permisoNombre);
    return true;
  }
}

class UsuarioPermisosService {
  static const String baseUrl = 'http://192.168.100.143:8000';
  static bool useMock = false; // 🔹 Flag para usar mock

  /// Asignar un permiso a un usuario
  static Future<bool> asignarPermiso({
    required int usuarioId,
    required int? permisoId, // puede ser null si es mock
    required String recursoTipo,
    int? recursoId,
    String? permisoNombre, // solo para mock
  }) async {
    if (useMock) {
      if (permisoNombre == null) return false;
      return MockPermisos.asignarPermiso(
        usuarioId: usuarioId,
        permisoNombre: permisoNombre,
      );
    }

    try {
      final url = Uri.parse('$baseUrl/usuario_permisos/');
      final body = {
        'usuario_id': usuarioId,
        'permiso_id': permisoId,
        'recurso_tipo': recursoTipo,
        'recurso_id': recursoId,
      };
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Excepción asignar permiso: $e');
      return false;
    }
  }

  /// Obtener permisos de un usuario
  static Future<List<String>> obtenerPermisosUsuario(int usuarioId) async {
    if (useMock) {
      return MockPermisos.obtenerPermisosUsuario(usuarioId);
    }

    try {
      final url = Uri.parse('$baseUrl/usuario_permisos/$usuarioId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List permisos = data['permisos'];
        return permisos
            .map<String>((p) => p['permiso']['nombre'] as String)
            .toList();
      } else {
        print('Error obtener permisos usuario: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Excepción obtener permisos usuario: $e');
      return [];
    }
  }
}

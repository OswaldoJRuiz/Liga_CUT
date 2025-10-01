import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:liga/data/mock_permisos.dart';
import 'api_config.dart';

class UsuarioPermisosService {
  /// Verifica la conexión con FastAPI
  static Future<void> verificarConexion() async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/ping');
      final response = await http.get(url).timeout(Duration(seconds: 3));
      if (response.statusCode == 200) {
        print('✅ FastAPI UsuarioPermisos accesible: ${response.body}');
      } else {
        print(
          '⚠️ FastAPI UsuarioPermisos respondió con status ${response.statusCode}',
        );
      }
    } catch (e) {
      print('❌ No se pudo conectar a FastAPI UsuarioPermisos: $e');
    }
  }

  /// Asigna un permiso a un usuario
  static Future<bool> asignarPermiso({
    required int usuarioId,
    required int? permisoId,
    required String recursoTipo,
    int? recursoId,
    String? permisoNombre, // solo para mock
  }) async {
    if (ApiConfig.useMock) {
      if (permisoNombre == null) return false;
      return MockPermisos.asignarPermiso(
        usuarioId: usuarioId,
        permisoNombre: permisoNombre,
      );
    }

    await verificarConexion();

    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/usuario_permisos/');
      final body = jsonEncode({
        'usuario_id': usuarioId,
        'permiso_id': permisoId,
        'recurso_tipo': recursoTipo,
        'recurso_id': recursoId,
      });

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Permiso asignado correctamente a usuario $usuarioId');
        return true;
      } else {
        print('⚠️ Error asignando permiso: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Excepción asignando permiso: $e');
      return false;
    }
  }

  /// Obtiene los permisos de un usuario
  static Future<List<String>> obtenerPermisosUsuario(int usuarioId) async {
    if (ApiConfig.useMock) {
      return MockPermisos.obtenerPermisosUsuario(usuarioId);
    }

    await verificarConexion();

    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/usuario_permisos/$usuarioId');
      final response = await http.get(url);

      if (response.statusCode != 200) {
        print('⚠️ Error obteniendo permisos usuario: ${response.body}');
        return [];
      }

      final data = jsonDecode(response.body);
      final List permisos = data['permisos'] ?? [];

      final permisosLista = permisos
          .map<String>((p) => p['permiso']?['nombre']?.toString() ?? '')
          .where((name) => name.isNotEmpty)
          .toList();

      print('✅ Permisos obtenidos para usuario $usuarioId: $permisosLista');
      return permisosLista;
    } catch (e) {
      print('❌ Excepción obteniendo permisos usuario: $e');
      return [];
    }
  }
}

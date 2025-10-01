import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/permisos_model.dart';
import 'api_config.dart';

class PermisosService {
  static Future<void> verificarConexion() async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/ping');
      final response = await http.get(url).timeout(Duration(seconds: 3));
      if (response.statusCode == 200) {
        print('✅ FastAPI Permisos accesible: ${response.body}');
      } else {
        print(
          '⚠️ FastAPI Permisos respondió con status ${response.statusCode}',
        );
      }
    } catch (e) {
      print('❌ No se pudo conectar a FastAPI Permisos: $e');
    }
  }

  static Future<Permiso?> crearPermiso(Permiso permiso) async {
    await verificarConexion();
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/permisos/');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(permiso.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Permiso.fromJson(data);
      } else {
        print('⚠️ Error crear permiso: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Excepción crear permiso: $e');
      return null;
    }
  }

  static Future<List<Permiso>> obtenerPermisos() async {
    await verificarConexion();
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/permisos/');
      final response = await http.get(url);

      if (response.statusCode != 200) {
        print('⚠️ Error al obtener permisos: ${response.body}');
        return [];
      }

      final data = jsonDecode(response.body);
      final List permisosJson = data['permisos'] ?? [];
      return permisosJson.map((e) => Permiso.fromJson(e)).toList();
    } catch (e) {
      print('❌ Excepción obtener permisos: $e');
      return [];
    }
  }
}

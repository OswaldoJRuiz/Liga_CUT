import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:liga/models/equipos_model.dart';
import 'package:liga/data/db_equipos_helper.dart';
import 'api_config.dart';

Future<void> verificarConexionEquipos() async {
  try {
    final url = Uri.parse('${ApiConfig.baseUrl}/ping');
    final response = await http.get(url).timeout(Duration(seconds: 3));
    if (response.statusCode == 200) {
      print('✅ FastAPI Equipos accesible: ${response.body}');
    } else {
      print('⚠️ FastAPI Equipos respondió con status ${response.statusCode}');
    }
  } catch (e) {
    print('❌ No se pudo conectar a FastAPI Equipos: $e');
  }
}

Future<List<Equipo>> _obtenerEquiposLocales() async {
  final equipos = await DBEquiposHelper.getEquipos();
  print("🗄️ Equipos cargados desde SQLite: ${equipos.length}");
  return equipos;
}

Future<List<Equipo>> obtenerEquipos({
  int timeoutSegundos = 3,
  Function? onTimeout,
}) async {
  if (ApiConfig.useMock) return await _obtenerEquiposLocales();

  await verificarConexionEquipos();

  try {
    final url = Uri.parse('${ApiConfig.baseUrl}/equipos/');
    final response = await http
        .get(url)
        .timeout(
          Duration(seconds: timeoutSegundos),
          onTimeout: () {
            if (onTimeout != null) onTimeout();
            throw TimeoutException('Tiempo de espera agotado');
          },
        );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List equiposJson = data['equipos'];
      final equipos = equiposJson.map((e) => Equipo.fromJson(e)).toList();

      await DBEquiposHelper.clearEquipos();
      for (var e in equipos) {
        await DBEquiposHelper.insertEquipo(e);
      }

      print('✅ Equipos obtenidos desde FastAPI: ${equipos.length}');
      return equipos;
    } else {
      print(
        '⚠️ Error ${response.statusCode} al obtener equipos, cargando SQLite...',
      );
      return await _obtenerEquiposLocales();
    }
  } catch (e) {
    print('❌ Error al obtener equipos: $e');
    return await _obtenerEquiposLocales();
  }
}

Future<Map<String, dynamic>> crearEquipo(Equipo equipo, int usuarioId) async {
  if (ApiConfig.useMock) return {"exito": true, "data": equipo.toJson()};

  await verificarConexionEquipos();

  try {
    final url = Uri.parse(
      '${ApiConfig.baseUrl}/equipos/?usuario_id=$usuarioId',
    );
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(equipo.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return {"exito": true, "data": data};
    } else {
      final error = jsonDecode(response.body);
      return {
        "exito": false,
        "mensaje": error['detail'] ?? "Error al crear equipo",
      };
    }
  } catch (e) {
    return {"exito": false, "mensaje": "Excepción: $e"};
  }
}

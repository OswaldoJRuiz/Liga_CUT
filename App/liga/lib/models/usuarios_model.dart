import 'package:liga/models/permisos_model.dart';

class Usuario {
  final int? id;
  final String nombreUsuario;
  final String correo;
  final String contrasena;
  final List<Permiso> permisos;

  Usuario({
    this.id,
    required this.nombreUsuario,
    required this.correo,
    required this.contrasena,
    required this.permisos,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    final permisosJson = json['permisos'] as List<dynamic>? ?? [];
    return Usuario(
      id: json['id'] as int?,
      nombreUsuario: json['nombre_usuario'] as String? ?? '', // ⚡ aquí cambia
      correo: json['correo'] as String? ?? '',
      contrasena: json['contrasena'] as String? ?? '',
      permisos: permisosJson.map((p) => Permiso.fromJson(p)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre_usuario': nombreUsuario, // ⚡ aquí también snake_case
      'correo': correo,
      'contrasena': contrasena,
      'permisos': permisos.map((p) => p.toJson()).toList(),
    };
  }

  // 🔹 Getter que devuelve solo los nombres de los permisos
  List<String> get permisosNombres => permisos.map((p) => p.nombre).toList();
}

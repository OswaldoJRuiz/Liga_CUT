import 'package:liga/models/usuarios_model.dart';
import 'package:liga/models/permisos_model.dart';

class MockUsuarios {
  static final usuarios = <Usuario>[
    Usuario(
      id: 1,
      nombreUsuario: "admin",
      correo: "admin@test.com",
      permisos: [
        Permiso(nombre: "gestionar_liga"),
        Permiso(nombre: "gestionar_equipo"),
        Permiso(nombre: "agregar_jugador"),
      ],
      contrasena: 'Kanibal1',
    ),
    Usuario(
      id: 2,
      nombreUsuario: "capitan",
      correo: "capitan@test.com",
      permisos: [Permiso(nombre: "gestionar_equipo")],
      contrasena: 'Kanibal1',
    ),
    Usuario(
      id: 3, // cambié el id para no repetir el 3
      nombreUsuario: "invitado",
      correo: "invitado@test.com",
      permisos: [], // invitado no tiene permisos
      contrasena: 'Kanibal1',
    ),
  ];

  /// Simula login comparando correo y devolviendo usuario
  static Future<Usuario?> login(String correo, String contrasena) async {
    // 🔹 Aquí no validamos contraseña, solo correo (para desarrollo)
    await Future.delayed(const Duration(milliseconds: 500)); // simula delay
    try {
      return usuarios.firstWhere((u) => u.correo == correo);
    } catch (_) {
      return null;
    }
  }
}

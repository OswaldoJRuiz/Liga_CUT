import 'package:flutter/material.dart';
import 'package:liga/core/custom_widgets/custom_sliver_appbar.dart';
import 'package:liga/data/permission_guard.dart';
import 'package:liga/models/equipos_model.dart';
import 'package:liga/services/equipos_service.dart';
import 'package:liga/notifiers/usuario_notifier.dart';

class GestionScreen extends StatefulWidget {
  const GestionScreen({super.key});

  @override
  State<GestionScreen> createState() => _GestionScreenState();
}

class _GestionScreenState extends State<GestionScreen> {
  Equipo? miEquipo;
  bool creando = false;
  List<String> integrantes = [];

  @override
  void initState() {
    super.initState();
    _cargarEquipo();
  }

  /// ---------------------- Cargar equipo del usuario ----------------------
  Future<void> _cargarEquipo() async {
    final usuario = UsuarioNotifier.instance.usuario;
    final usuarioId = usuario?.id;

    if (usuarioId == null) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Usuario no válido")));
      }
      return;
    }

    try {
      final equipos = await obtenerEquipos();
      final equipoUsuario = equipos.firstWhereOrNull(
        (e) => e.propietarioId == usuarioId,
      );

      setState(() {
        miEquipo = equipoUsuario;

        // Datos falsos para integrantes si no hay API
        integrantes = equipoUsuario != null
            ? ["Jugador 1", "Jugador 2", "Jugador 3"]
            : [];
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Error al cargar equipo")));
      }
    }
  }

  /// ---------------------- Mostrar formulario para crear equipo ----------------------
  Future<void> _mostrarFormularioCrearEquipo() async {
    String nombre = '';
    String director = '';

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Crear Equipo"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: "Nombre del equipo"),
              onChanged: (v) => nombre = v,
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Director Técnico"),
              onChanged: (v) => director = v,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _crearEquipoConDatos(nombre, director);
            },
            child: const Text("Crear"),
          ),
        ],
      ),
    );
  }

  /// ---------------------- Crear equipo con los datos del formulario ----------------------
  Future<void> _crearEquipoConDatos(String nombre, String director) async {
    setState(() => creando = true);

    final usuarioId = UsuarioNotifier.instance.usuario?.id;
    if (usuarioId == null) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Usuario no válido")));
      }
      setState(() => creando = false);
      return;
    }

    final nuevo = Equipo(nombre: nombre, directorTecnico: director);

    try {
      final response = await crearEquipo(nuevo, usuarioId);

      if (response['exito'] == true) {
        setState(() {
          miEquipo = Equipo.fromJson(response['data']);
          // Datos falsos para integrantes
          integrantes = ["Jugador 1", "Jugador 2", "Jugador 3"];
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['mensaje'] ?? "Error desconocido")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Error al crear equipo")));
      }
    }

    setState(() => creando = false);
  }

  @override
  Widget build(BuildContext context) {
    final usuarioId = UsuarioNotifier.instance.usuario?.id;
    print("Usuario ID actual: $usuarioId");

    return PermissionGuard(
      requeridos: ['gestionar_equipo'],
      fallback: const Center(
        child: Text(
          "No tienes permisos para acceder a esta sección",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      child: CustomScrollView(
        slivers: [
          const CustomSliverAppbar(title: "Gestión"),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (miEquipo == null) ...[
                    ElevatedButton.icon(
                      onPressed: creando ? null : _mostrarFormularioCrearEquipo,
                      icon: const Icon(Icons.group_add),
                      label: creando
                          ? const Text("Creando...")
                          : const Text("Crear Equipo"),
                    ),
                  ] else ...[
                    Text(
                      "Equipo: ${miEquipo?.nombre ?? 'No definido'}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Director Técnico: ${miEquipo?.directorTecnico ?? 'No definido'}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Integrantes:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DataTable(
                      columns: const [DataColumn(label: Text("Nombre"))],
                      rows: integrantes
                          .map((i) => DataRow(cells: [DataCell(Text(i))]))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------------- Extensión de seguridad ----------------------
extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

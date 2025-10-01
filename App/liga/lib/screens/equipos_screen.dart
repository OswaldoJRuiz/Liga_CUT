import 'package:flutter/material.dart';
import 'package:liga/core/components/filtrar_equipos.dart';
import 'package:liga/core/custom_widgets/custom_button.dart';
import 'package:liga/core/custom_widgets/custom_sliver_appbar.dart';
import 'package:liga/data/db_equipos_helper.dart';
import 'package:liga/models/equipos_model.dart';
import 'package:liga/services/equipos_service.dart';
import 'package:liga/core/custom_widgets/equipo_card.dart';
import 'package:liga/data/permission_helper.dart';

class EquiposCache {
  static List<Equipo>? equipos;
}

class EquiposScreen extends StatefulWidget {
  const EquiposScreen({super.key}); // ✅ Sin permisos

  @override
  State<EquiposScreen> createState() => EquiposScreenState();
}

class EquiposScreenState extends State<EquiposScreen>
    with SingleTickerProviderStateMixin {
  String filtro = "Todos";
  late AnimationController _controller;
  List<Equipo> equipos = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _cargarEquipos();
  }

  Future<void> cargarEquipos() async => _cargarEquipos();

  Future<void> _cargarEquipos() async {
    setState(() => cargando = true);

    if (EquiposCache.equipos != null) {
      setState(() {
        equipos = EquiposCache.equipos!;
        cargando = false;
      });
      _controller.forward();
      return;
    }

    final locales = await DBEquiposHelper.getEquipos();
    if (!mounted) return;

    setState(() {
      equipos = locales;
      cargando = false;
    });
    _controller.forward();

    try {
      final remotos = await obtenerEquipos(
        onTimeout: () {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Tiempo de espera agotado. Mostrando datos locales.',
                ),
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
      );

      final cambio =
          remotos.length != locales.length ||
          !remotos.every((e) => locales.any((l) => l.id == e.id));

      if (cambio && mounted) {
        setState(() {
          equipos = remotos;
        });
      }

      EquiposCache.equipos = remotos;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No se pudo conectar al servidor. Mostrando datos locales.',
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  List<Equipo> getEquiposFiltrados() {
    if (filtro == "Todos") return equipos;
    return equipos.where((e) => e.nombre == filtro).toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get puedeAnadirEquipo {
    final permisosPermitidos = ['gestionar_liga', 'gestionar_equipo'];
    return permisosActuales(context).alguno(permisosPermitidos);
  }

  @override
  Widget build(BuildContext context) {
    final equiposFiltrados = getEquiposFiltrados();

    return cargando
        ? const Center(child: CircularProgressIndicator())
        : CustomScrollView(
            slivers: [
              const CustomSliverAppbar(title: "Equipos"),

              if (puedeAnadirEquipo)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: CustomButton(
                      text: "Añadir Equipo",
                      onPressed: () {
                        // Lógica para añadir equipo
                      },
                      width: double.infinity,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      textColor: Colors.white,
                      borderRadius: 12,
                      fontSize: 16,
                      icon: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: FiltrarEquipos(
                    valorActual: filtro,
                    equipos: equipos,
                    onFiltroCambiado: (nuevoFiltro) {
                      setState(() {
                        filtro = nuevoFiltro;
                        _controller.reset();
                        _controller.forward();
                      });
                    },
                  ),
                ),
              ),

              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final animation = Tween<double>(begin: 0, end: 1).animate(
                    CurvedAnimation(
                      parent: _controller,
                      curve: Interval(
                        index / equiposFiltrados.length,
                        1.0,
                        curve: Curves.easeIn,
                      ),
                    ),
                  );

                  final equipo = equiposFiltrados[index];

                  return FadeTransition(
                    opacity: animation,
                    child: EquipoCard(
                      equipo: equipo,
                      onTap: () {
                        // Navegar a detalles del equipo si quieres
                      },
                    ),
                  );
                }, childCount: equiposFiltrados.length),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          );
  }
}

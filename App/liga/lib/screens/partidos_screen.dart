import 'package:flutter/material.dart';
import 'package:liga/core/components/filtrar_fechas.dart';
import 'package:liga/core/custom_widgets/custom_sliver_appbar.dart';
import 'package:liga/core/custom_widgets/partido_card.dart';
import 'package:liga/models/partidos_model.dart';
import 'package:liga/data/partidos_data.dart';

class PartidosScreen extends StatefulWidget {
  const PartidosScreen({super.key});

  @override
  State<PartidosScreen> createState() => _PartidosScreenState();
}

class _PartidosScreenState extends State<PartidosScreen>
    with SingleTickerProviderStateMixin {
  String filtro = "Todos";
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Partido> getPartidosFiltrados() {
    if (filtro == "Todos") return partidos;
    return partidos.where((p) => p.fecha == filtro).toList();
  }

  @override
  Widget build(BuildContext context) {
    final partidosFiltrados = getPartidosFiltrados();

    return CustomScrollView(
      slivers: [
        const CustomSliverAppbar(title: "Partidos"),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: FiltrarFechas(
              valorActual: filtro,
              partidos: partidos,
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
            final anim = CurvedAnimation(
              parent: _controller,
              curve: Interval(
                index / partidosFiltrados.length,
                1.0,
                curve: Curves.easeInOut,
              ),
            );

            final partido = partidosFiltrados[index];

            return FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.05),
                  end: Offset.zero,
                ).animate(anim),
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.995, end: 1.0).animate(anim),
                  child: PartidoCard(partido: partido),
                ),
              ),
            );
          }, childCount: partidosFiltrados.length),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}

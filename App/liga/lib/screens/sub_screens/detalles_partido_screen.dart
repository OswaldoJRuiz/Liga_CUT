import 'package:flutter/material.dart';
import 'package:liga/models/partidos_model.dart';
import 'package:liga/core/custom_widgets/custom_sliver_appbar.dart';

class DetallesPartidoScreen extends StatelessWidget {
  final Partido partido;

  const DetallesPartidoScreen({super.key, required this.partido});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppbar(
            title: "${partido.equipoA} vs ${partido.equipoB}",
            pinned: false,
            floating: true,
            snap: true,
            expandedHeight: 112,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: textColor),
              onPressed: () => Navigator.pop(context),
            ),
            bottomCenterWidget: Image.asset(
              'assets/images/LogoCUT.png',
              height: 160, // tamaño del logo centrado
              fit: BoxFit.contain,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card principal
                  Card(
                    color: cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.sports_soccer,
                                size: 20,
                                color: textColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "${partido.equipoA} vs ${partido.equipoB}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 16,
                                    color: textColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    partido.fecha,
                                    style: TextStyle(color: textColor),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: textColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    partido.hora,
                                    style: TextStyle(color: textColor),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color: textColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                partido.estadio,
                                style: TextStyle(color: textColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Card detalles adicionales
                  Card(
                    color: cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Detalles adicionales",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Aquí puedes agregar alineaciones, estadísticas, resultados previos y cualquier información relevante del partido.",
                            style: TextStyle(color: textColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:liga/data/partidos_data.dart';
import 'package:liga/core/custom_widgets/custom_card.dart';

class ProxPartidosCard extends StatelessWidget {
  const ProxPartidosCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 190,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.85),
        itemCount: partidos.length,
        itemBuilder: (context, index) {
          final partido = partidos[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: CustomCard(
              borderRadius: 12,
              backgroundColor: isDark ? const Color(0xFF2C3E50) : Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
              onTap: () {
                // Acción al tocar la card
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${partido.equipoA} vs ${partido.equipoB}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white, // texto blanco siempre
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${partido.fecha} - ${partido.hora}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white, // texto blanco siempre
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    partido.estadio,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white, // texto blanco siempre
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:liga/models/partidos_model.dart';
import 'package:liga/screens/sub_screens/detalles_partido_screen.dart';
import 'package:liga/core/custom_widgets/custom_card.dart';

class PartidoCard extends StatelessWidget {
  final Partido partido;

  const PartidoCard({super.key, required this.partido});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = Colors.white; // siempre sobre el gradiente

    return CustomCard(
      withScaleAnimation: true,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetallesPartidoScreen(partido: partido),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título con equipos
          Text(
            "${partido.equipoA} vs ${partido.equipoB}",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: textColor,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),

          // Fila con fecha y hora con iconos
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: textColor),
                  const SizedBox(width: 4),
                  Text(partido.fecha, style: TextStyle(color: textColor)),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: textColor),
                  const SizedBox(width: 4),
                  Text(partido.hora, style: TextStyle(color: textColor)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Lugar del partido con icono
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: textColor),
              const SizedBox(width: 4),
              Text(partido.estadio, style: TextStyle(color: textColor)),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:liga/core/custom_widgets/custom_card.dart';
import 'package:liga/models/equipos_model.dart';

class EquipoCard extends StatelessWidget {
  final Equipo equipo;
  final VoidCallback? onTap;

  const EquipoCard({super.key, required this.equipo, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CustomCard(
      withScaleAnimation: true,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            equipo.nombre,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isDark ? Colors.white : Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Director: ${equipo.directorTecnico}",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? Colors.white70 : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

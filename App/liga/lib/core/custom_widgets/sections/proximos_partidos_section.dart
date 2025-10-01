import 'package:flutter/material.dart';
import 'package:liga/core/custom_widgets/prox_partidos_card.dart';

class ProximosPartidosSection extends StatelessWidget {
  const ProximosPartidosSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Text(
            "Próximos partidos",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black, // título negro en modo claro
            ),
          ),

          SizedBox(height: 12), // separación entre título y tarjetas
          ProxPartidosCard(),
        ],
      ),
    );
  }
}

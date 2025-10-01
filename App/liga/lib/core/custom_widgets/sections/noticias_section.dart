import 'package:flutter/material.dart';
import 'package:liga/core/custom_widgets/noticias_card.dart';
import 'package:liga/data/noticias_data.dart';

/// NoticiasSection
///
/// Sección que lista las noticias.
/// Ahora es un widget normal (Column) en lugar de Sliver.
class NoticiasSection extends StatelessWidget {
  const NoticiasSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: noticias.map((noticia) {
        return NoticiasCard(
          titulo: noticia.titulo,
          descripcion: noticia.descripcion,
        );
      }).toList(),
    );
  }
}

import 'package:flutter/material.dart';
import '../../data/permission_helper.dart';

/// Barra de navegación inferior personalizada con colores dinámicos
class CustomNavbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomNavbar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 🔹 Obtenemos los permisos del usuario activo de manera segura
    final permisos = permisosActuales(context);

    // Colores según tema
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedColor = Theme.of(context).colorScheme.primary;
    final unselectedColor = isDark ? Colors.white70 : Colors.black54;
    final backgroundColor = isDark ? const Color(0xFF1B2434) : Colors.white;

    // Items base
    final items = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
      const BottomNavigationBarItem(
        icon: Icon(Icons.sports_soccer),
        label: "Partidos",
      ),
      const BottomNavigationBarItem(icon: Icon(Icons.group), label: "Equipos"),
    ];

    // Añadimos Gestión solo si tiene permiso
    if (permisos.tiene('gestionar_equipo') ||
        permisos.tiene('gestionar_liga')) {
      items.add(
        const BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "Gestión",
        ),
      );
    }

    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onTap,
      backgroundColor: backgroundColor,
      selectedItemColor: selectedColor,
      unselectedItemColor: unselectedColor,
      type: BottomNavigationBarType.fixed,
      items: items,
    );
  }
}

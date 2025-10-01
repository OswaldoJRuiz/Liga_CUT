import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Este es el AppBar que siempre esta ahi activo y que solo se manda a llamar a Home_Screen ⊙﹏⊙∥ //

/// AppBar personalizado para la aplicación.
///
/// Características:
/// - Adapta su altura según la orientación (vertical u horizontal).
/// - Ajusta el color y estilo de la barra de estado según el tema (claro/oscuro).
/// - Permite recibir un título y acciones adicionales.
class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  /// Texto que aparece como título en el AppBar.
  final String title;

  /// Lista opcional de widgets para mostrar como acciones.
  final List<Widget>? actions;

  const CustomAppbar({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    // Detecta si la pantalla está en horizontal
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    // Ajusta la altura en base a la orientación
    final height = isLandscape ? 48.0 : kToolbarHeight;

    return SafeArea(
      child: SizedBox(
        height: height,
        child: AppBar(
          toolbarHeight: height,
          elevation: 0,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          // Cambia el estilo de la barra de estado según el tema
          systemOverlayStyle: Theme.of(context).brightness == Brightness.dark
              ? SystemUiOverlayStyle.light.copyWith(
                  statusBarColor: Theme.of(context).appBarTheme.backgroundColor,
                )
              : SystemUiOverlayStyle.dark.copyWith(
                  statusBarColor: Theme.of(context).appBarTheme.backgroundColor,
                ),
          title: Text(
            title,
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          iconTheme: Theme.of(context).appBarTheme.iconTheme,
          centerTitle: true,
          actions: actions,
        ),
      ),
    );
  }

  /// Define el tamaño preferido del AppBar.
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

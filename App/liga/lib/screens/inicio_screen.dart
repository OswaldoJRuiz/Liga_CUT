import 'package:flutter/material.dart';
import 'package:liga/core/custom_widgets/custom_banner.dart';
import 'package:liga/core/custom_widgets/custom_sliver_appbar.dart';
import 'package:liga/core/custom_widgets/sections/noticias_section.dart';
import 'package:liga/core/custom_widgets/sections/proximos_partidos_section.dart';
import 'package:liga/core/custom_widgets/tabla_de_posiciones.dart';
import 'package:liga/notifiers/usuario_notifier.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  int selectedIndex = 0;
  final List<String> options = ["Próximos", "Noticias", "Extras"];

  @override
  Widget build(BuildContext context) {
    // 🔹 Obtener usuario de forma segura
    final usuario = UsuarioNotifier.instance.usuario;
    final nombreUsuario = usuario?.nombreUsuario ?? "Invitado";
    final userId = usuario?.id ?? 0;

    print("Usuario actual: $nombreUsuario, ID: $userId");

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? const Color.fromARGB(255, 27, 36, 52)
        : const Color.fromARGB(255, 224, 236, 242);

    final borderColor = isDark
        ? Colors.white.withAlpha((0.05 * 255).round())
        : Colors.black.withAlpha((0.05 * 255).round());

    final unselectedTextColor = isDark
        ? Colors.grey[300]
        : Theme.of(context).colorScheme.primary;

    return CustomScrollView(
      slivers: [
        const CustomSliverAppbar(title: "Inicio"),

        // 🔹 Carrusel
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: CustomBanner(),
          ),
        ),

        // 🔹 Tabla de posiciones
        SliverToBoxAdapter(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const TablaDePosiciones(),
          ),
        ),

        // 🔹 Caja dinámica estilizada
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Container(
              constraints: const BoxConstraints(minHeight: 150),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor, width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: List.generate(options.length, (index) {
                        final isSelected = selectedIndex == index;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: index == 0 ? 0 : 6),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.transparent,
                                foregroundColor: isSelected
                                    ? Colors.white
                                    : unselectedTextColor,
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                elevation: isSelected ? 2 : 0,
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              child: Text(
                                options[index],
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                      child: Padding(
                        key: ValueKey(selectedIndex),
                        padding: const EdgeInsets.only(top: 8),
                        child: selectedIndex == 0
                            ? const ProximosPartidosSection()
                            : selectedIndex == 1
                            ? const NoticiasSection()
                            : const Center(child: Text("Otras cosas aquí")),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

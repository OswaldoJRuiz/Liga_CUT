import 'dart:async';
import 'package:flutter/material.dart';
import 'package:liga/animations/animation_presets.dart';
import 'package:liga/core/components/mixins/safestate.dart';
import 'package:liga/core/custom_widgets/custom_drawer.dart';
import 'package:liga/core/custom_widgets/custom_navbar.dart';
import 'package:liga/screens/inicio_screen.dart';
import 'package:liga/screens/partidos_screen.dart';
import 'package:liga/screens/equipos_screen.dart';
import 'package:liga/screens/gestion_screen.dart';
import 'package:liga/notifiers/usuario_notifier.dart';
import 'package:liga/notifiers/permisos_notifier.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SafeState {
  int selectedIndex = 0;
  late final List<Widget> _cachedScreens;
  bool _showReloadOverlay = false;

  final GlobalKey<EquiposScreenState> equiposScreenKey =
      GlobalKey<EquiposScreenState>();

  Timer? _overlayDebounce; // Debounce para cambios rápidos

  @override
  void initState() {
    super.initState();

    // Construir todas las pantallas una sola vez
    _cachedScreens = [
      const InicioScreen(),
      const PartidosScreen(),
      EquiposScreen(key: equiposScreenKey),
      if (PermisosNotifier.instance.tienePermiso('gestionar_equipo') ||
          PermisosNotifier.instance.tienePermiso('gestionar_liga'))
        const GestionScreen(),
    ];

    // Escuchamos cambios solo para overlay
    UsuarioNotifier.instance.addListener(_onUsuarioOrPermisosChange);
    PermisosNotifier.instance.addListener(_onUsuarioOrPermisosChange);
  }

  @override
  void dispose() {
    UsuarioNotifier.instance.removeListener(_onUsuarioOrPermisosChange);
    PermisosNotifier.instance.removeListener(_onUsuarioOrPermisosChange);
    _overlayDebounce?.cancel();
    super.dispose();
  }

  void _onUsuarioOrPermisosChange() {
    // Cancelar timer previo si existía
    _overlayDebounce?.cancel();

    // Iniciar uno nuevo
    _overlayDebounce = Timer(const Duration(milliseconds: 200), () async {
      if (!mounted) return;

      safeSetOverlay(true);
      await Future.delayed(const Duration(milliseconds: 250));
      safeSetOverlay(false);
    });
  }

  void safeSetOverlay(bool value) {
    if (!mounted) return;
    safeSetState(() => _showReloadOverlay = value);
  }

  void _onTabSelected(int index) {
    if (index < 0 || index >= _cachedScreens.length) return;
    safeSetState(() => selectedIndex = index);

    if (_cachedScreens[selectedIndex] is EquiposScreen) {
      equiposScreenKey.currentState?.cargarEquipos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          drawer: const CustomDrawer(),
          bottomNavigationBar: CustomNavbar(
            selectedIndex: selectedIndex,
            onTap: _onTabSelected,
          ),
          body: presetFadeScreen(
            _cachedScreens[selectedIndex],
            selectedIndex: selectedIndex,
          ),
        ),
        if (_showReloadOverlay)
          Container(
            color: Colors.black26,
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}

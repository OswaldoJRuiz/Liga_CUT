import 'package:flutter/material.dart';
import 'package:liga/animations/animation_presets.dart';
import 'package:liga/notifiers/usuario_notifier.dart';
import 'package:liga/notifiers/permisos_notifier.dart';
import 'package:liga/theme/theme_constants.dart';
import 'package:liga/theme/theme_manager.dart';
import 'package:liga/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("🔹 Inicializando themeManager...");
  await themeManager.loadTheme();

  print("🔹 Inicializando UsuarioNotifier...");
  await UsuarioNotifier.init();

  print("🔹 Inicializando PermisosNotifier...");
  await PermisosNotifier.init();

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool _showOverlay = false;

  @override
  void initState() {
    super.initState();
    themeManager.addListener(_showQuickOverlay);
    UsuarioNotifier.instance.addListener(_showQuickOverlay);
    PermisosNotifier.instance.addListener(_showQuickOverlay);
  }

  @override
  void dispose() {
    themeManager.removeListener(_showQuickOverlay);
    UsuarioNotifier.instance.removeListener(_showQuickOverlay);
    PermisosNotifier.instance.removeListener(_showQuickOverlay);
    super.dispose();
  }

  void _showQuickOverlay() async {
    if (!mounted) return;
    setState(() => _showOverlay = true);
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    setState(() => _showOverlay = false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeManager.themeMode,
      builder: (context, child) {
        return Stack(
          children: [
            AnimatedTheme(
              data: themeManager.themeMode == ThemeMode.dark
                  ? darkTheme
                  : lightTheme,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: child ?? const SizedBox(),
            ),
            IgnorePointer(child: presetThemeOverlay(_showOverlay)),
          ],
        );
      },
      home: const HomeScreen(),
    );
  }
}

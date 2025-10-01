import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Clase que gestiona el tema (claro u oscuro) de la aplicación.
///
/// - Usa ChangeNotifier para notificar a los widgets que deben redibujarse
///   cuando cambie el tema.
/// - Guarda y recupera la preferencia del usuario con SharedPreferences.
class ThemeManager with ChangeNotifier {
  /// Tema actual de la app. Por defecto empieza en claro.
  ThemeMode _themeMode = ThemeMode.light;

  /// Getter público para acceder al tema actual.
  ThemeMode get themeMode => _themeMode;

  /// Clave usada para guardar en SharedPreferences la preferencia de tema.
  static const _key = 'isDarkTheme';

  /// Cambia el tema de la app entre oscuro y claro.
  ///
  /// - isDark: si es `true`, activa modo oscuro; si es `false`, claro.
  /// - Notifica a los listeners (por ejemplo, MaterialApp) para que actualicen.
  /// - Guarda la preferencia en SharedPreferences para que se recuerde
  ///   la próxima vez que el usuario abra la app.
  void toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners(); // Actualiza UI

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, isDark); // Guarda preferencia
  }

  /// Carga la preferencia del tema al iniciar la app.
  ///
  /// - Obtiene la configuración almacenada en SharedPreferences.
  /// - Si no existe (primer inicio), por defecto se usa tema claro.
  /// - Una vez cargado, notifica a los listeners para que la UI muestre
  ///   el tema correcto desde el arranque.
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_key) ?? false;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners(); // Actualiza UI
  }
}

/// Instancia global del ThemeManager.
///
/// Se usa para que toda la app tenga un único administrador de temas.
final ThemeManager themeManager = ThemeManager();

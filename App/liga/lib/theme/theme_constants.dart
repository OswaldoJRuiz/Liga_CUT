import 'package:flutter/material.dart';

// Light Theme
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Color.fromARGB(255, 234, 244, 253), // fondo general
  cardColor: Color.fromARGB(255, 178, 192, 230),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 198, 216, 248),
    elevation: 0,
    iconTheme: IconThemeData(color: Color(0xFF0f172a)),
    titleTextStyle: TextStyle(
      color: Color(0xFF0f172a),
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF0f172a)), // Texto principal
    bodyMedium: TextStyle(color: Color(0xFF475569)), // Texto secundario
  ),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFFD34165), // Azul CUT
    secondary: Color(0xF0E4B164), // Verde CUT
    surface: Colors.white,
    onSurface: Color(0xFF0f172a),
    error: Color(0xFFdc2626),
  ),
);

// Dark Theme
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color.fromARGB(
    255,
    30,
    41,
    59,
  ), // Fondo principal
  cardColor: const Color.fromARGB(255, 20, 64, 102), // Tarjetas, navbar
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 15, 23, 42),
    elevation: 0,
    iconTheme: IconThemeData(color: Color(0xFFe2e8f0)),
    titleTextStyle: TextStyle(
      color: Color(0xFFe2e8f0),
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFFe2e8f0)), // texto principal
    bodyMedium: TextStyle(color: Color(0xFF94a3b8)), // texto secundario
  ),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF14149D), // Verde CUT
    secondary: Color(0xFF2C40AF), // Azul CUT
    surface: Color(0xFF273752),
    onSurface: Color(0xFFe2e8f0),
    error: Color(0xFFef4444),
  ),
);

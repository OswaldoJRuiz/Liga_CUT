import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuarios_model.dart';

class SessionManager {
  static Usuario? currentUser;

  static Future<Usuario?> getUser() async {
    if (currentUser != null) return currentUser;
    await loadUser();
    return currentUser;
  }

  static Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJsonStr = prefs.getString('usuario');

    if (userJsonStr != null) {
      final Map<String, dynamic> userMap = jsonDecode(userJsonStr);
      currentUser = Usuario.fromJson(userMap);
    } else {
      currentUser = null;
    }
  }

  static Future<void> setUser(Usuario user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('usuario', jsonEncode(user.toJson()));
    currentUser = user;
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('usuario');
    currentUser = null;
  }
}

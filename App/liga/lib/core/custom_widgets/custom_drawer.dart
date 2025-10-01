import 'package:flutter/material.dart';
import 'package:liga/core/app_colors.dart';
import 'package:liga/core/components/custom_switch_theme.dart';
import 'package:liga/models/permisos_model.dart';
import 'package:liga/models/usuarios_model.dart';
import 'package:liga/notifiers/usuario_notifier.dart';
import 'package:liga/screens/home_screen.dart';
import 'package:liga/screens/sub_screens/login_modal.dart';
import 'package:liga/theme/theme_manager.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  void initState() {
    super.initState();
    themeManager.addListener(_onThemeChanged);
    UsuarioNotifier.instance.addListener(_onUsuarioChanged);
  }

  @override
  void dispose() {
    themeManager.removeListener(_onThemeChanged);
    UsuarioNotifier.instance.removeListener(_onUsuarioChanged);
    super.dispose();
  }

  void _onThemeChanged() => setState(() {});
  void _onUsuarioChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // 🔹 Usuario seguro
    Usuario usuario =
        UsuarioNotifier.instance.usuario ??
        Usuario(
          id: 0,
          nombreUsuario: 'Invitado',
          correo: '',
          contrasena: '',
          permisos: [],
        );

    // 🔹 Si es invitado, nos aseguramos que tenga el permiso "ver_liga"
    if (usuario.id == 0 &&
        !usuario.permisos.any((p) => p.nombre == 'ver_liga')) {
      usuario.permisos.add(Permiso(nombre: 'ver_liga'));
    }

    final isInvitado = usuario.id == 0;
    final isDark = themeManager.themeMode == ThemeMode.dark;

    // 🔹 Colores del drawer y header
    final drawerStart = isDark
        ? DrawerColors.startDark
        : const Color(0xFFD3DDED);
    final drawerEnd = isDark ? DrawerColors.endDark : const Color(0xFFC8E2F8);
    final headerStart = drawerEnd;
    final headerEnd = drawerStart;
    final textColor = isDark ? Colors.white : Colors.black;

    return Drawer(
      width: screenWidth * 0.65,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [drawerStart, drawerEnd],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [headerStart, headerEnd],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: UserAccountsDrawerHeader(
                margin: EdgeInsets.zero,
                decoration: const BoxDecoration(),
                accountName: Text(
                  usuario.nombreUsuario,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                accountEmail: Text(
                  isInvitado ? 'Invitado' : 'Usuario registrado',
                  style: TextStyle(color: textColor),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons
                        .person, // 🔹 Icono de persona en lugar de la primera letra
                    size: 32,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: textColor),
              title: Text('Inicio', style: TextStyle(color: textColor)),
              onTap: () => Navigator.pop(context),
            ),
            ExpansionTile(
              leading: Icon(Icons.settings, color: textColor),
              title: Text('Configuración', style: TextStyle(color: textColor)),
              children: [
                ListTile(
                  title: Text('Tema', style: TextStyle(color: textColor)),
                  trailing: CustomSwitchTheme(
                    value: isDark,
                    onChanged: (val) => themeManager.toggleTheme(val),
                    activeColor: const Color(0xFF212141),
                    inactiveColor: const Color(0xFFEAF4FD),
                    activeThumbColor: const Color(0xFFEAF4FD),
                    inactiveThumbColor: const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            isInvitado
                ? ListTile(
                    leading: Icon(Icons.login, color: textColor),
                    title: Text(
                      'Iniciar sesión',
                      style: TextStyle(color: textColor),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const LoginModal(),
                      );
                    },
                  )
                : ListTile(
                    leading: Icon(Icons.logout, color: textColor),
                    title: Text(
                      'Cerrar sesión',
                      style: TextStyle(color: textColor),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      UsuarioNotifier.instance.logout();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

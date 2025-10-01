import 'package:flutter/material.dart';
import 'package:liga/core/components/mixins/safestate.dart';
import 'package:liga/core/custom_widgets/custom_button.dart';
import 'package:liga/notifiers/usuario_notifier.dart';
import 'package:liga/screens/register_screen.dart';
import 'package:liga/screens/home_screen.dart';

class LoginModal extends StatefulWidget {
  const LoginModal({super.key});

  @override
  State<LoginModal> createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> with SafeState<LoginModal> {
  final _formKey = GlobalKey<FormState>();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  bool _isLoading = false;

  Future<void> _loginUsuario() async {
    if (!_formKey.currentState!.validate()) return;

    safeSetState(() => _isLoading = true);

    final exito = await UsuarioNotifier.instance.login(
      _correoController.text.trim(),
      _contrasenaController.text.trim(),
    );

    safeSetState(() => _isLoading = false);

    if (exito) {
      safeNavigator?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } else {
      safeSnackBar(
        const SnackBar(content: Text('Correo o contraseña incorrectos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF1A1A2E), const Color(0xFF27293D)]
                  : [Colors.white, Colors.grey[100]!],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            // Permite scroll si el teclado ocupa espacio
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Iniciar Sesión',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _correoController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) => v != null && v.contains('@')
                              ? null
                              : 'Correo inválido',
                          decoration: InputDecoration(
                            labelText: 'Correo',
                            labelStyle: TextStyle(
                              color: isDark
                                  ? Colors.grey[300]
                                  : Colors.grey[700],
                            ),
                            filled: true,
                            fillColor: isDark
                                ? const Color(0xFF2C2F44)
                                : Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _contrasenaController,
                          obscureText: true,
                          validator: (v) => v != null && v.length >= 6
                              ? null
                              : 'Mínimo 6 caracteres',
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            labelStyle: TextStyle(
                              color: isDark
                                  ? Colors.grey[300]
                                  : Colors.grey[700],
                            ),
                            filled: true,
                            fillColor: isDark
                                ? const Color(0xFF2C2F44)
                                : Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : CustomButton(
                                text: 'Login',
                                onPressed: _loginUsuario,
                                width: double.infinity,
                                height: 50,
                                borderRadius: 12,
                                fontSize: 16,
                              ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            safeNavigator?.push(
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) =>
                                    const RegisterScreen(),
                                transitionDuration: const Duration(
                                  milliseconds: 250,
                                ),
                                transitionsBuilder: (_, animation, __, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: Text(
                            '¿No tienes cuenta? Regístrate',
                            style: TextStyle(color: textColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

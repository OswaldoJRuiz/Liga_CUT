import 'package:flutter/material.dart';
import 'package:liga/core/components/mixins/safestate.dart';
import 'package:liga/models/usuarios_model.dart';
import 'package:liga/services/usuarios_servcie.dart';
import '../core/custom_widgets/custom_sliver_appbar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SafeState {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  bool _isLoading = false;

  void _registrarUsuario() async {
    if (!_formKey.currentState!.validate()) return;

    safeSetState(() => _isLoading = true);

    final usuario = Usuario(
      id: null, // 🔹 en registro todavía no existe
      nombreUsuario: _nombreController.text.trim(),
      correo: _correoController.text.trim(),
      contrasena: _contrasenaController.text.trim(),
      permisos: [], // 🔹 invitado sin permisos al inicio
    );

    final resultado = await UsuariosService.registrarUsuario(usuario);

    safeSetState(() => _isLoading = false);

    if (resultado != null) {
      safeSnackBar(
        const SnackBar(content: Text('Usuario registrado correctamente!')),
      );
      safeNavigator?.pop();
    } else {
      safeSnackBar(const SnackBar(content: Text('Error al registrar usuario')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CustomSliverAppbar(
            title: 'Registro',
            pinned: true,
            leading: BackButton(),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre de usuario',
                      ),
                      validator: (v) => v!.isEmpty ? 'Ingrese un nombre' : null,
                    ),
                    TextFormField(
                      controller: _correoController,
                      decoration: const InputDecoration(labelText: 'Correo'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) =>
                          v!.contains('@') ? null : 'Correo inválido',
                    ),
                    TextFormField(
                      controller: _contrasenaController,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                      ),
                      obscureText: true,
                      validator: (v) =>
                          v!.length >= 6 ? null : 'Mínimo 6 caracteres',
                    ),
                    const SizedBox(height: 20),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _registrarUsuario,
                            child: const Text('Registrarse'),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

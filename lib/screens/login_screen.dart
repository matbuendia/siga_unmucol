import 'package:flutter/material.dart';
import '../services/auth_service.dart'; // Asegúrate de que la ruta sea correcta

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 1. Controladores para capturar el texto
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService(); // Instancia de tu servicio
  bool _isLoading = false; // Para mostrar un círculo de carga

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Tu fondo de imagen (se mantiene igual)
          Opacity(
            opacity: 1,
            child: Image.asset(
              'assets/images/plantillalogin.png',
              width: double.infinity, // Mejor usar infinity para cubrir todo
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              // Evita que el teclado tape los campos
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(
                    0.9,
                  ), // Un poco de transparencia queda elegante
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'SIGA-UNMUCOL',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 128, 18, 148),
                        shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Campo Email
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Campo Password
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Botón de Login con lógica
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : _handleLogin, // Desactiva si está cargando
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            176,
                            97,
                            189,
                          ),
                          foregroundColor: Colors.white,
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text('Login'),
                      ),
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

  // 2. Función lógica para el Login
  void _handleLogin() async {
    setState(() => _isLoading = true);

    final user = await _authService.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (user != null) {
      final rol = await _authService.getRole(user.uid);

      if (!mounted) return;

      // 3. Redirección por roles
      if (rol == 'admin') {
        print("Bienvenido Admin");
        Navigator.pushReplacementNamed(context, '/admin_panel');
        // Navigator.pushReplacementNamed(context, '/admin_dashboard');
      } else {
        print("Bienvenido Alumno");
        Navigator.pushReplacementNamed(context, '/planner');
        // Navigator.pushReplacementNamed(context, '/student_home');
      }
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: Credenciales inválidas")),
      );
    }

    setState(() => _isLoading = false);
  }
}

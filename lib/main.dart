import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // IMPORTANTE
import 'firebase_options.dart'; // El archivo que generó flutterfire
import 'screens/login_screen.dart'; // Importa tu login
import 'screens/planner_screen.dart';
import 'package:siga_unmucol/screens/admin_screen.dart';

void main() async {
  // 1. Asegura que Flutter esté listo
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Conecta con Firebase en tu Fedora/Brave/Android
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SIGA UNMUCOL',

      // 3. Define la pantalla inicial
      initialRoute: '/',

      // 4. El "Mapa de Navegación" por nombres
      routes: {
        '/': (context) => const LoginScreen(),
        '/planner': (context) => const PlannerScreen(),
        '/admin_panel': (context) => const AdminScreen(),
      },
    );
  }
}

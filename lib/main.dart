import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/router_screen.dart';
import 'screens/students_screens/home_screen.dart';
import 'screens/admin_screens/home_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SIGA UNMUCOL',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/router': (context) => const RouterScreen(),
        '/home/student': (context) => const HomeScreen(),
        '/home/admin': (context) => const AdminHomeScreen(),
      },
    );
  }
}

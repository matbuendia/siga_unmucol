import 'package:flutter/material.dart';
//import 'screens/login_screen.dart';
import 'screens/students_screens/planner_screen.dart';
//import 'screens/students_screens/curse_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mi proyecto',

      home: const PlannerScreen(),
    );
  }
}

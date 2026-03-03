import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/curse_screen.dart';
import 'screens/planner_screen.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp( 
      debugShowCheckedModeBanner: false,
      title: 'Mi proyecto',

      home: const LoginScreen(),
    );
  }
}

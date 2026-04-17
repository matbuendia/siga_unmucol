import 'package:flutter/material.dart';
import 'package:siga_unmucol/services/session_service.dart';

class RouterScreen extends StatefulWidget {
  const RouterScreen({super.key});

  @override
  State<RouterScreen> createState() => _RouterScreenState();
}

class _RouterScreenState extends State<RouterScreen> {
  @override
  void initState() {
    super.initState();
    _redirigir();
  }

  Future<void> _redirigir() async {
    final rol = await SessionService.getRol();

    if (!mounted) return;

    if (rol == 'student') {
      Navigator.pushReplacementNamed(context, '/home/student');
    } else {
      await SessionService.clearSession();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: Color(0xFF6A1B9A)),
      ),
    );
  }
}
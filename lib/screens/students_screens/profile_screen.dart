import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Datos mock — después vendrán de la API
  final String nombre = 'Juan Pérez';
  final String correo = 'juan@unmucol.edu.co';
  final String curso = '5A';
  final String periodo = '2026-1';
  final List<double> promediosMaterias = const [3.83, 4.43, 3.5];

  double get promedioAcumulado {
    return promediosMaterias.reduce((a, b) => a + b) / promediosMaterias.length;
  }

  Color _colorPromedio(double promedio) {
    if (promedio >= 4.0) return const Color(0xFF2E7D32);
    if (promedio >= 3.0) return const Color(0xFFF57F17);
    return const Color(0xFFC62828);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A1B9A),
        title: const Text('Mi perfil', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Avatar con iniciales
            CircleAvatar(
              radius: 48,
              backgroundColor: const Color(0xFF6A1B9A),
              child: Text(
                nombre.split(' ').map((e) => e[0]).take(2).join(),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Nombre y correo
            Text(
              nombre,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6A1B9A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              correo,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Promedio acumulado destacado
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    'Promedio acumulado',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    promedioAcumulado.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: _colorPromedio(promedioAcumulado),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    promedioAcumulado >= 3.0 ? 'Aprobado' : 'En riesgo',
                    style: TextStyle(
                      fontSize: 13,
                      color: _colorPromedio(promedioAcumulado),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Información académica
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Información académica',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6A1B9A),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _filaInfo(Icons.class_, 'Curso', curso),
                  const Divider(height: 24),
                  _filaInfo(Icons.calendar_today, 'Periodo', periodo),
                  const Divider(height: 24),
                  _filaInfo(
                    Icons.school,
                    'Materias cursando',
                    '${promediosMaterias.length} materias',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Botón cerrar sesión
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                icon: const Icon(Icons.exit_to_app, color: Color(0xFF6A1B9A)),
                label: const Text(
                  'Cerrar sesión',
                  style: TextStyle(color: Color(0xFF6A1B9A), fontSize: 16),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF6A1B9A)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _filaInfo(IconData icono, String label, String valor) {
    return Row(
      children: [
        Icon(icono, size: 20, color: const Color(0xFF9C27B0)),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        const Spacer(),
        Text(
          valor,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

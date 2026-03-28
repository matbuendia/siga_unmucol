import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel SIGA - UNMUCOL'),
        backgroundColor: const Color.fromARGB(255, 128, 18, 148),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2, // Dos columnas
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            _adminCard(
              context,
              Icons.person_add,
              "Crear Usuario",
              Colors.blue,
              '/register',
            ),
            _adminCard(
              context,
              Icons.people,
              "Ver Alumnos",
              Colors.green,
              '/user_list',
            ),
            _adminCard(
              context,
              Icons.book,
              "Gestionar Cursos",
              Colors.orange,
              '/courses_admin',
            ),
            _adminCard(
              context,
              Icons.analytics,
              "Reportes",
              Colors.red,
              '/reports',
            ),
          ],
        ),
      ),
    );
  }

  Widget _adminCard(
    BuildContext context,
    IconData icon,
    String title,
    Color color,
    String route,
  ) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

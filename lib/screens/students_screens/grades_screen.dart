import 'package:flutter/material.dart';

class GradesScreen extends StatelessWidget {
  const GradesScreen({super.key});

  // Datos mock — después vendrán de la API
  final List<Map<String, dynamic>> materias = const [
    {
      'materia': 'Matemáticas',
      'profesor': 'Prof. Orlando Martínez',
      'periodo1': 3.8,
      'periodo2': 4.2,
      'periodo3': 3.5,
    },
    {
      'materia': 'Lenguaje',
      'profesor': 'Prof. Stefanny Pinzón',
      'periodo1': 4.5,
      'periodo2': 4.0,
      'periodo3': 4.8,
    },
    {
      'materia': 'Ciencias',
      'profesor': 'Prof. Carlos Ruiz',
      'periodo1': 3.0,
      'periodo2': 3.5,
      'periodo3': 4.0,
    },
  ];

  // Calcula el promedio de los tres periodos
  double calcularPromedio(double p1, double p2, double p3) {
    return (p1 + p2 + p3) / 3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A1B9A),
        title: const Text(
          'Mis calificaciones',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: materias.length,
        itemBuilder: (context, index) {
          final m = materias[index];
          final promedio = calcularPromedio(
            m['periodo1'],
            m['periodo2'],
            m['periodo3'],
          );

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ExpansionTile(
              title: Text(
                m['materia'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF6A1B9A),
                ),
              ),
              subtitle: Text(
                m['profesor'],
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    children: [
                      _filaNota('Periodo 1', m['periodo1']),
                      _filaNota('Periodo 2', m['periodo2']),
                      _filaNota('Periodo 3', m['periodo3']),
                      const Divider(),
                      _filaNota('Nota final', promedio, esFinal: true),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _filaNota(String label, double nota, {bool esFinal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: esFinal ? FontWeight.bold : FontWeight.normal,
              fontSize: esFinal ? 15 : 14,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _colorNota(nota),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              nota.toStringAsFixed(1),
              style: TextStyle(
                color: Colors.white,
                fontWeight: esFinal ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Verde si >= 3.0, rojo si es menor
  Color _colorNota(double nota) {
    if (nota >= 3.0) return const Color(0xFF2E7D32);
    return const Color(0xFFC62828);
  }
}

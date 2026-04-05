import 'package:flutter/material.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  DateTime _selectedDay = DateTime.now();
  late PageController _pageController;

  // Datos mock — después vendrán de la API
  final List<Map<String, dynamic>> _eventos = [
    {
      'titulo': 'Reunión de padres',
      'descripcion': 'Mañana a las 8am en el auditorio',
      'fecha': DateTime.now(),
      'tipo': 'global',
      'curso': null,
    },
    {
      'titulo': 'Entrega taller',
      'descripcion': 'Traer el taller resuelto',
      'fecha': DateTime.now().add(const Duration(days: 2)),
      'tipo': 'curso',
      'curso': 'Matemáticas',
    },
    {
      'titulo': 'Día del estudiante',
      'descripcion': 'No hay clases',
      'fecha': DateTime.now().add(const Duration(days: 5)),
      'tipo': 'global',
      'curso': null,
    },
    {
      'titulo': 'Quiz de lenguaje',
      'descripcion': 'Repasar capítulos 3 y 4',
      'fecha': DateTime.now().add(const Duration(days: 2)),
      'tipo': 'curso',
      'curso': 'Lenguaje',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Genera los días desde hoy hacia el futuro
  List<DateTime> _generarDias() {
    return List.generate(60, (i) => DateTime.now().add(Duration(days: i)));
  }

  // Filtra eventos del día seleccionado
  List<Map<String, dynamic>> _eventosDel(DateTime dia) {
    return _eventos.where((e) {
      final fecha = e['fecha'] as DateTime;
      return fecha.year == dia.year &&
          fecha.month == dia.month &&
          fecha.day == dia.day;
    }).toList();
  }

  // Verifica si un día tiene eventos
  bool _tieneEventos(DateTime dia) {
    return _eventosDel(dia).isNotEmpty;
  }

  String _nombreMes(int mes) {
    const meses = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];
    return meses[mes - 1];
  }

  String _nombreDia(int dia) {
    const dias = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    return dias[dia - 1];
  }

  Color _colorTipo(String tipo) {
    if (tipo == 'global') return const Color(0xFF6A1B9A);
    return const Color(0xFF2E7D32);
  }

  Color _colorFondoTipo(String tipo) {
    if (tipo == 'global') return const Color(0xFFEDE7F6);
    return const Color(0xFFE8F5E9);
  }

  IconData _iconoTipo(String tipo) {
    if (tipo == 'global') return Icons.campaign;
    return Icons.book;
  }

  @override
  Widget build(BuildContext context) {
    final dias = _generarDias();
    final eventosDia = _eventosDel(_selectedDay);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A1B9A),
        title: const Text('Planner', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          // Tira de días
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SizedBox(
              height: 72,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: dias.length,
                itemBuilder: (context, index) {
                  final dia = dias[index];
                  final isSelected =
                      dia.year == _selectedDay.year &&
                      dia.month == _selectedDay.month &&
                      dia.day == _selectedDay.day;
                  final tieneEventos = _tieneEventos(dia);

                  return GestureDetector(
                    onTap: () => setState(() => _selectedDay = dia),
                    child: Container(
                      width: 48,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF6A1B9A)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _nombreDia(dia.weekday),
                            style: TextStyle(
                              fontSize: 10,
                              color: isSelected
                                  ? const Color(0xFFCE93D8)
                                  : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${dia.day}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: tieneEventos
                                  ? isSelected
                                        ? const Color(0xFFCE93D8)
                                        : const Color(0xFF6A1B9A)
                                  : Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Fecha seleccionada
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Text(
                  '${_selectedDay.day} de ${_nombreMes(_selectedDay.month)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6A1B9A),
                  ),
                ),
                const SizedBox(width: 8),
                if (eventosDia.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6A1B9A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${eventosDia.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),

          // Lista de eventos
          Expanded(
            child: eventosDia.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_available,
                          size: 48,
                          color: Color(0xFFCE93D8),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Sin eventos para este día',
                          style: TextStyle(
                            color: Color(0xFF9C27B0),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: eventosDia.length,
                    itemBuilder: (context, index) {
                      final evento = eventosDia[index];
                      final tipo = evento['tipo'] as String;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            // Franja de color
                            Container(
                              width: 4,
                              height: 72,
                              decoration: BoxDecoration(
                                color: _colorTipo(tipo),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                              ),
                            ),
                            // Ícono
                            Container(
                              margin: const EdgeInsets.all(12),
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: _colorFondoTipo(tipo),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                _iconoTipo(tipo),
                                color: _colorTipo(tipo),
                                size: 18,
                              ),
                            ),
                            // Contenido
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 4,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      evento['titulo'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      evento['descripcion'],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _colorFondoTipo(tipo),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        tipo == 'global'
                                            ? 'Global'
                                            : evento['curso'],
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: _colorTipo(tipo),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

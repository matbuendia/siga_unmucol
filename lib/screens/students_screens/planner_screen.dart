import 'package:flutter/material.dart';
import 'package:siga_unmucol/services/api_service.dart';
import 'package:siga_unmucol/services/session_service.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  DateTime _selectedDay = DateTime.now();
  List<dynamic> _eventos = [];
  bool _isLoading = true;
  String? _error;

  final List<DateTime> _dias = List.generate(
    90,
    (i) => DateTime.now().add(Duration(days: i - 30)),
  );

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _loadEvents();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadEvents() async {
    try {
      final studentId = await SessionService.getUserId();
      if (studentId == null) throw Exception('Sesión no encontrada');
      final data = await ApiService.getEvents(studentId);
      setState(() {
        _eventos = data;
        _isLoading = false;
      });
      _scrollToToday();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _scrollToToday() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final index = _dias.indexWhere((d) =>
          d.year == DateTime.now().year &&
          d.month == DateTime.now().month &&
          d.day == DateTime.now().day);
      if (index != -1) {
        _scrollController.animateTo(
          index * 64.0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  List<dynamic> _eventosDel(DateTime dia) {
    return _eventos.where((e) {
      final fecha = DateTime.parse(e['fecha']);
      return fecha.year == dia.year &&
          fecha.month == dia.month &&
          fecha.day == dia.day;
    }).toList();
  }

  bool _tieneEventos(DateTime dia) => _eventosDel(dia).isNotEmpty;

  String _nombreDia(int weekday) {
    const dias = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    return dias[weekday - 1];
  }

  String _nombreMesCompleto(int mes) {
    const meses = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return meses[mes - 1];
  }

  bool _esHoy(DateTime dia) {
    final hoy = DateTime.now();
    return dia.year == hoy.year &&
        dia.month == hoy.month &&
        dia.day == hoy.day;
  }

  bool _esSeleccionado(DateTime dia) {
    return dia.year == _selectedDay.year &&
        dia.month == _selectedDay.month &&
        dia.day == _selectedDay.day;
  }

  Color _colorTipo(String tipo) {
    if (tipo == 'global') return const Color(0xFF6A1B9A);
    return const Color(0xFF1565C0);
  }

  Color _colorFondoTipo(String tipo) {
    if (tipo == 'global') return const Color(0xFFEDE7F6);
    return const Color(0xFFE3F2FD);
  }

  IconData _iconoTipo(String tipo) {
    if (tipo == 'global') return Icons.campaign;
    return Icons.menu_book;
  }

  @override
  Widget build(BuildContext context) {
    final eventosDia = _eventosDel(_selectedDay);

    return Scaffold(
      backgroundColor: const Color(0xFF6A1B9A),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Planner',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${_selectedDay.day} de ${_nombreMesCompleto(_selectedDay.month)} ${_selectedDay.year}',
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Tira de días
            SizedBox(
              height: 76,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _dias.length,
                itemBuilder: (context, index) {
                  final dia = _dias[index];
                  final seleccionado = _esSeleccionado(dia);
                  final hoy = _esHoy(dia);
                  final tieneEventos = _tieneEventos(dia);

                  return GestureDetector(
                    onTap: () => setState(() => _selectedDay = dia),
                    child: Container(
                      width: 52,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: seleccionado
                            ? Colors.white
                            : Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                        border: hoy && !seleccionado
                            ? Border.all(
                                color: Colors.white.withOpacity(0.6),
                                width: 1.5,
                              )
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _nombreDia(dia.weekday),
                            style: TextStyle(
                              fontSize: 10,
                              color: seleccionado
                                  ? const Color(0xFF6A1B9A)
                                  : Colors.white60,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${dia.day}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: seleccionado
                                  ? const Color(0xFF6A1B9A)
                                  : Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: tieneEventos
                                  ? seleccionado
                                      ? const Color(0xFF6A1B9A)
                                      : Colors.white
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

            const SizedBox(height: 16),

            // Body
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F0FF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF6A1B9A),
                        ),
                      )
                    : _error != null
                        ? Center(
                            child: Text(_error!,
                                style: const TextStyle(color: Colors.red)),
                          )
                        : eventosDia.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 72,
                                      height: 72,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEDE7F6),
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: const Icon(
                                        Icons.event_available,
                                        size: 36,
                                        color: Color(0xFF6A1B9A),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Sin eventos para este día',
                                      style: TextStyle(
                                        color: Color(0xFF6A1B9A),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Selecciona otro día en el calendario',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : RefreshIndicator(
                                color: const Color(0xFF6A1B9A),
                                onRefresh: _loadEvents,
                                child: ListView.builder(
                                  padding: const EdgeInsets.fromLTRB(
                                      16, 24, 16, 16),
                                  itemCount: eventosDia.length,
                                  itemBuilder: (context, index) {
                                    return _EventoCard(
                                      evento: eventosDia[index],
                                      colorTipo: _colorTipo(
                                          eventosDia[index]['tipo']),
                                      colorFondo: _colorFondoTipo(
                                          eventosDia[index]['tipo']),
                                      icono: _iconoTipo(
                                          eventosDia[index]['tipo']),
                                    );
                                  },
                                ),
                              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventoCard extends StatelessWidget {
  final Map<String, dynamic> evento;
  final Color colorTipo;
  final Color colorFondo;
  final IconData icono;

  const _EventoCard({
    required this.evento,
    required this.colorTipo,
    required this.colorFondo,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    final tipo = evento['tipo'] as String;
    final curso = evento['curso'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: colorTipo.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Franja lateral
          Container(
            width: 5,
            height: 80,
            decoration: BoxDecoration(
              color: colorTipo,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                bottomLeft: Radius.circular(18),
              ),
            ),
          ),
          // Ícono
          Container(
            margin: const EdgeInsets.all(14),
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colorFondo,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icono, color: colorTipo, size: 20),
          ),
          // Contenido
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    evento['titulo'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF2D2D2D),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    evento['contenido'],
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: colorFondo,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tipo == 'global' ? 'Global' : (curso ?? 'Curso'),
                      style: TextStyle(
                        fontSize: 10,
                        color: colorTipo,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}
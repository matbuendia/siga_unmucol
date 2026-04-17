import 'package:flutter/material.dart';
import 'package:siga_unmucol/services/api_service.dart';
import 'package:siga_unmucol/services/session_service.dart';

class GradesScreen extends StatefulWidget {
  const GradesScreen({super.key});

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  Map<String, dynamic>? _data;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadGrades();
  }

  Future<void> _loadGrades() async {
    try {
      final studentId = await SessionService.getUserId();
      if (studentId == null) throw Exception('Sesión no encontrada');
      final data = await ApiService.getGrades(studentId);
      setState(() {
        _data = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6A1B9A),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mis calificaciones',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_data != null)
                        Text(
                          _data!['estudiante'],
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed: _loadGrades,
                    ),
                  ),
                ],
              ),
            ),

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
                            child: Text(
                              _error!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          )
                        : _data!['materias'].isEmpty
                            ? const Center(
                                child: Text('No tienes materias inscritas'),
                              )
                            : RefreshIndicator(
                                color: const Color(0xFF6A1B9A),
                                onRefresh: _loadGrades,
                                child: ListView.builder(
                                  padding: const EdgeInsets.fromLTRB(
                                      16, 24, 16, 16),
                                  itemCount: _data!['materias'].length,
                                  itemBuilder: (context, index) {
                                    return _MateriaCard(
                                      materia: _data!['materias'][index],
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

class _MateriaCard extends StatelessWidget {
  final Map<String, dynamic> materia;
  const _MateriaCard({required this.materia});

  @override
  Widget build(BuildContext context) {
    final periodos = materia['periodos'] as List;
    final notaFinal = materia['nota_final'];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6A1B9A).withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          childrenPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8E24AA), Color(0xFF6A1B9A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.menu_book, color: Colors.white, size: 22),
          ),
          title: Text(
            materia['materia'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color(0xFF2D2D2D),
            ),
          ),
          subtitle: Text(
            materia['profesor'],
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          trailing: notaFinal != null
              ? _ChipNota(
                  nota: (notaFinal as num).toDouble(),
                  size: 15,
                )
              : const Icon(Icons.keyboard_arrow_down,
                  color: Color(0xFF6A1B9A)),
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F5FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  ...periodos.asMap().entries.map((entry) {
                    final isLast = entry.key == periodos.length - 1;
                    return _PeriodoTile(
                      periodo: entry.value,
                      isLast: isLast,
                    );
                  }),
                  if (notaFinal != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: const BoxDecoration(
                        color: Color(0xFF6A1B9A),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(14),
                          bottomRight: Radius.circular(14),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Nota final de la materia',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            (notaFinal as num).toDouble().toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PeriodoTile extends StatelessWidget {
  final Map<String, dynamic> periodo;
  final bool isLast;
  const _PeriodoTile({required this.periodo, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final numeroPeriodo = periodo['periodo'];
    final nota = periodo['nota'];
    final cerrado = periodo['cerrado'] as bool;
    final actividades = periodo['actividades'] as List? ?? [];

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        childrenPadding: EdgeInsets.zero,
        title: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: cerrado
                    ? const Color(0xFF6A1B9A)
                    : const Color(0xFF6A1B9A).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'P$numeroPeriodo',
                  style: TextStyle(
                    color:
                        cerrado ? Colors.white : const Color(0xFF6A1B9A),
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Periodo $numeroPeriodo',
              style: const TextStyle(
                  fontSize: 14, color: Color(0xFF2D2D2D)),
            ),
            if (cerrado)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF6A1B9A).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Cerrado',
                  style: TextStyle(
                      fontSize: 10, color: Color(0xFF6A1B9A)),
                ),
              ),
          ],
        ),
        trailing: nota != null
            ? _ChipNota(nota: (nota as num).toDouble(), size: 13)
            : const Text('—',
                style: TextStyle(color: Colors.grey, fontSize: 14)),
        children: [
          if (actividades.isEmpty)
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Text(
                'Sin actividades registradas aún',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: Column(
                children: actividades
                    .map<Widget>((a) => _ActividadRow(actividad: a))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class _ActividadRow extends StatelessWidget {
  final Map<String, dynamic> actividad;
  const _ActividadRow({required this.actividad});

  IconData _icono(String tipo) {
    switch (tipo) {
      case 'quiz':
        return Icons.quiz;
      case 'examen':
        return Icons.assignment;
      case 'taller':
        return Icons.build;
      default:
        return Icons.star;
    }
  }

  Color _colorNota(double nota) {
    if (nota >= 4.0) return const Color(0xFF2E7D32);
    if (nota >= 3.0) return const Color(0xFFF9A825);
    return const Color(0xFFC62828);
  }

  @override
  Widget build(BuildContext context) {
    final tipo = actividad['tipo'] as String;
    final descripcion = actividad['descripcion'] ?? tipo;
    final valor = (actividad['valor'] as num).toDouble();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(_icono(tipo), size: 15, color: _colorNota(valor)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              descripcion,
              style: const TextStyle(fontSize: 13, color: Color(0xFF444444)),
            ),
          ),
          _ChipNota(nota: valor, size: 12),
        ],
      ),
    );
  }
}

class _ChipNota extends StatelessWidget {
  final double nota;
  final double size;
  const _ChipNota({required this.nota, required this.size});

  Color _color() {
    if (nota >= 4.0) return const Color(0xFF2E7D32);
    if (nota >= 3.0) return const Color(0xFFF9A825);
    return const Color(0xFFC62828);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size > 13 ? 12 : 8,
        vertical: size > 13 ? 5 : 3,
      ),
      decoration: BoxDecoration(
        color: _color(),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        nota.toStringAsFixed(1),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: size,
        ),
      ),
    );
  }
}
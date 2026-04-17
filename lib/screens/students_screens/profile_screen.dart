import 'package:flutter/material.dart';
import 'package:siga_unmucol/services/api_service.dart';
import 'package:siga_unmucol/services/session_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _nombre;
  String? _correo;
  double? _promedio;
  int _totalMaterias = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final nombre = await SessionService.getNombre();
    final correo = await SessionService.getToken();
    final studentId = await SessionService.getUserId();

    double? promedio;
    int total = 0;

    if (studentId != null) {
      try {
        final data = await ApiService.getGrades(studentId);
        final materias = data['materias'] as List;
        total = materias.length;

        final notas = materias
            .map((m) => m['nota_final'])
            .where((n) => n != null)
            .map((n) => (n as num).toDouble())
            .toList();

        if (notas.isNotEmpty) {
          promedio = notas.reduce((a, b) => a + b) / notas.length;
        }
      } catch (_) {}
    }

    setState(() {
      _nombre = nombre ?? 'Estudiante';
      _correo = correo;
      _promedio = promedio;
      _totalMaterias = total;
      _isLoading = false;
    });
  }

  String _initiales(String nombre) {
    final partes = nombre.trim().split(' ');
    if (partes.length >= 2) {
      return '${partes[0][0]}${partes[1][0]}'.toUpperCase();
    }
    return nombre.isNotEmpty ? nombre[0].toUpperCase() : '?';
  }

  Color _colorPromedio(double p) {
    if (p >= 4.0) return const Color(0xFF2E7D32);
    if (p >= 3.0) return const Color(0xFFF9A825);
    return const Color(0xFFC62828);
  }

  Future<void> _logout() async {
    await SessionService.clearSession();
    if (mounted) Navigator.pushReplacementNamed(context, '/');
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
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mi perfil',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Avatar
            if (!_isLoading)
              Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.5),
                    ),
                    child: Center(
                      child: Text(
                        _initiales(_nombre ?? ''),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _nombre ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Estudiante',
                    style: TextStyle(color: Colors.white60, fontSize: 13),
                  ),
                ],
              ),

            const SizedBox(height: 24),

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
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const SizedBox(height: 8),

                            // Promedio acumulado
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF6A1B9A)
                                        .withOpacity(0.07),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Promedio acumulado',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  _promedio != null
                                      ? Text(
                                          _promedio!.toStringAsFixed(1),
                                          style: TextStyle(
                                            fontSize: 56,
                                            fontWeight: FontWeight.bold,
                                            color: _colorPromedio(_promedio!),
                                          ),
                                        )
                                      : const Text(
                                          '—',
                                          style: TextStyle(
                                            fontSize: 56,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ),
                                        ),
                                  const SizedBox(height: 6),
                                  if (_promedio != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 4),
                                      decoration: BoxDecoration(
                                        color:
                                            _colorPromedio(_promedio!).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        _promedio! >= 3.0
                                            ? 'Aprobado'
                                            : 'En riesgo',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: _colorPromedio(_promedio!),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )
                                  else
                                    const Text(
                                      'Sin notas finales aún',
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.grey),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Estadísticas
                            Row(
                              children: [
                                Expanded(
                                  child: _StatCard(
                                    icono: Icons.menu_book,
                                    label: 'Materias',
                                    valor: '$_totalMaterias',
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _StatCard(
                                    icono: Icons.calendar_today,
                                    label: 'Año',
                                    valor: '2026',
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _StatCard(
                                    icono: Icons.bar_chart,
                                    label: 'Periodos',
                                    valor: '3',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Info personal
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF6A1B9A)
                                        .withOpacity(0.07),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Información',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF6A1B9A),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _FilaInfo(
                                    icono: Icons.person,
                                    label: 'Nombre',
                                    valor: _nombre ?? '—',
                                  ),
                                  const Divider(height: 24),
                                  _FilaInfo(
                                    icono: Icons.school,
                                    label: 'Rol',
                                    valor: 'Estudiante',
                                  ),
                                  const Divider(height: 24),
                                  _FilaInfo(
                                    icono: Icons.menu_book,
                                    label: 'Materias cursando',
                                    valor: '$_totalMaterias',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Botón cerrar sesión
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: OutlinedButton.icon(
                                onPressed: _logout,
                                icon: const Icon(Icons.exit_to_app,
                                    color: Color(0xFF6A1B9A)),
                                label: const Text(
                                  'Cerrar sesión',
                                  style: TextStyle(
                                    color: Color(0xFF6A1B9A),
                                    fontSize: 16,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      color: Color(0xFF6A1B9A)),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icono;
  final String label;
  final String valor;
  const _StatCard(
      {required this.icono, required this.label, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6A1B9A).withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icono, color: const Color(0xFF6A1B9A), size: 22),
          const SizedBox(height: 8),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D2D),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _FilaInfo extends StatelessWidget {
  final IconData icono;
  final String label;
  final String valor;
  const _FilaInfo(
      {required this.icono, required this.label, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icono, size: 18, color: const Color(0xFF9C27B0)),
        const SizedBox(width: 12),
        Text(label,
            style: const TextStyle(fontSize: 13, color: Colors.grey)),
        const Spacer(),
        Text(
          valor,
          style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

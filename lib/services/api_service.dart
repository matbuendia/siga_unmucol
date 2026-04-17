import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:siga_unmucol/config/api_config.dart';

class ApiService {
  static const String baseUrl = ApiConfig.baseUrl;

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Correo o contraseña incorrectos');
    }
  }

  static Future<List<dynamic>> getEstudiantes() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/estudiantes'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener estudiantes');
    }
  }
  
  static Future<Map<String, dynamic>> getGrades(String studentId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/grades/student/$studentId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener calificaciones');
    }
  }

  static Future<List<dynamic>> getEvents(String studentId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/events/student/$studentId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener eventos');
    }
  }
}
class UserModel {
  final String uid;
  final String email;
  final String name;
  final String role; // 'admin', 'teacher', 'student', 'staff'

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
  });

  // Convertir de un mapa de Firebase (JSON) a objeto Dart
  factory UserModel.fromMap(Map<String, dynamic> data, String id) {
    return UserModel(
      uid: id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      role: data['role'] ?? 'student', // Por defecto es estudiante
    );
  }

  // Convertir de objeto Dart a un mapa para guardar en Firebase
  Map<String, dynamic> toMap() {
    return {'email': email, 'name': name, 'role': role};
  }
}

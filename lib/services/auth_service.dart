import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Función para iniciar sesión
  Future<User?> login(String email, String password) async {
    try {
      // 1. Autentica con correo y contraseña
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      print("Error en Firebase Auth: $e");
      return null;
    }
  }

  // Función para obtener el ROL del usuario desde Firestore
  Future<String?> getRole(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc['rol']; // Retorna 'admin', 'student', etc.
      }
    } catch (e) {
      print("Error obteniendo rol: $e");
    }
    return null;
  }
}

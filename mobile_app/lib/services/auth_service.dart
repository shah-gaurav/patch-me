// Authentication service for Firebase
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;

  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  static Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }
}
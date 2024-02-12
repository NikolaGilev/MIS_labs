import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  Future<String> registerWithEmailAndPassword(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return email;
    } catch (e) {
      print("Error during registration: $e");
      throw Exception("Registration failed: $e");
    }
  }

  Future<String> signInWithEmailAndPassword(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return email;
    } catch (e) {
      print("Error during login: $e");
      throw Exception("Login failed: $e");
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

}

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Getter to listen for authentication state changes
  Stream<User?> get userChanges => _auth.authStateChanges();

  // Sign up with email and password
  Future<String?> signUp(String name, String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user?.updateDisplayName(name);
      return "User registered successfully";
    } catch (e) {
      return e.toString();
    }
  }

  // Login with email and password
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "Login successful";
    } catch (e) {
      return e.toString();
    }
  }

  // Logout the user
  Future<void> logout() async {
    await _auth.signOut();
  }
}

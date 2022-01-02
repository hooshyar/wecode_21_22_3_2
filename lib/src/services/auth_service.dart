import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//method to register the user using emaoil and password
// todo error handling
  Future<UserCredential?> registerWithEmailAndPassword(
      String email, String password) async {
    UserCredential theUserCredentials = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    return theUserCredentials;
  }

//method to login the user using email and password
// error handling
  Future<UserCredential?> loginWithEmailAndPassword(
      String email, String password) async {
    UserCredential theUserCredentials = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);

    return theUserCredentials;
  }

  Stream<User?> get authStatusChanges => _firebaseAuth.authStateChanges();
}

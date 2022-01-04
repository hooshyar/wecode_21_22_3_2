import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? theUser = FirebaseAuth
      .instance.currentUser; //to have the current user as the initial value

  void setTheUser(User? user) {
    theUser = user;
    notifyListeners();
  }

//method to register the user using emaoil and password
// todo error handling
  Future<UserCredential?> registerWithEmailAndPassword(
      String email, String password) async {
    UserCredential theUserCredentials = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    setTheUser(theUserCredentials.user);
    return theUserCredentials;
  }

//method to login the user using email and password
// error handling
  Future<UserCredential?> loginWithEmailAndPassword(
      String email, String password) async {
    UserCredential theUserCredentials = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    setTheUser(theUserCredentials.user);
    return theUserCredentials;
  }

  // logout method
  logOut() async {
    await _firebaseAuth.signOut();
    setTheUser(null);
  }

  Stream<User?> get authStatusChanges => _firebaseAuth.authStateChanges();
}

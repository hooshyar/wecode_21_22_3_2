import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:wecode_2021/src/data_models/general_user.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  GeneralUser? generalUser;
  String? theError;

  //a void func to set the error message
  void setTheError(String? err) {
    theError = err;
    notifyListeners();
  }

  Future<UserCredential> registerAnon() async {
    UserCredential _anonUser = await _firebaseAuth.signInAnonymously();
    _anonUser.user!.uid;
    return _anonUser;
  }

  Future<String?> generateTokenAndSave(String uid) async {
    String? _token = await _firebaseMessaging.getToken();
    _firebaseFirestore.collection('tokens').doc(_token).set({
      'token': _token,
      'uid': uid,
    });
    return _token;
  }

  sendANotif(String token) async {
    await _firebaseMessaging.sendMessage(
        to: token, data: ({}), messageId: 'send to $token');
  }

  // a void func which updates the value of the generalUser
  void setTheGeneralUser(GeneralUser theGUser) {
    generalUser = theGUser;
    notifyListeners();
  }

  Future<bool> fetchUserInfo(String uid) async {
    DocumentSnapshot _userSnap =
        await _firebaseFirestore.collection('users').doc(uid).get();
    if (_userSnap.exists) {
      //map the data to a general_user data model
      GeneralUser _generalUser =
          GeneralUser.fromMap(_userSnap.data() as Map<String, dynamic>);
      setTheGeneralUser(_generalUser);
      return true;
    } else {
      return false;
    }
  }

  Stream<List<GeneralUser>?> fetchAllUsersStream() {
    return _firebaseFirestore.collection('users').snapshots().map((event) =>
        event.docs.map((e) => GeneralUser.fromMap(e.data())).toList());
  }

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
    try {
      UserCredential theUserCredentials = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      setTheUser(theUserCredentials.user);
      setTheError(null);

      return theUserCredentials;
    } on FirebaseAuthException catch (e) {
      setTheError(e.message);
    }
  }

//method to login the user using email and password
// error handling
  Future<UserCredential?> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential theUserCredentials = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      setTheUser(theUserCredentials.user);
      // _firebaseFirestore
      //     .collection('users')
      //     .doc(theUserCredentials.user!.uid)
      //     .set({});
      //TODO: user from db
      setTheError(null);
      return theUserCredentials;
    } on FirebaseAuthException catch (err) {
      setTheError(err.message!);
      debugPrint("==========>>>>>>" + err.message!);
    }
  }

  // logout method
  logOut() async {
    await _firebaseAuth.signOut();
    setTheUser(null);
  }

  Stream<User?> get authStatusChanges => _firebaseAuth.authStateChanges();
}

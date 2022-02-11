import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wecode_2021/src/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wecode_2021/src/providers/nameProvider.dart';
import 'package:wecode_2021/src/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp().then((value) => print('initialized'));

  //notifications session
  // await FirebaseAuth.instance.signInAnonymously().then((userCredential) async {
  //   debugPrint('user id:' + userCredential.user!.uid);
  //   await FirebaseMessaging.instance.getToken().then((token) async {
  //     debugPrint('token: $token');
  //     await FirebaseFirestore.instance
  //         .collection('test_users')
  //         .doc(userCredential.user!.uid)
  //         .set({'uid': userCredential.user!.uid, 'token': token},
  //             SetOptions(merge: true));
  //   });
  // });
  runApp(
    MultiProvider(
      child: const AppView(),
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
      ],
    ),
  );
}

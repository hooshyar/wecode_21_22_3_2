import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wecode_2021/src/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wecode_2021/src/providers/nameProvider.dart';
import 'package:wecode_2021/src/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => print('initialized'));
  runApp(
    MultiProvider(
      child: const AppView(),
      providers: [
        ChangeNotifierProvider(create: (context) => TheNameProvider()),
        ChangeNotifierProvider(create: (context) => AuthService()),
      ],
    ),
  );
}

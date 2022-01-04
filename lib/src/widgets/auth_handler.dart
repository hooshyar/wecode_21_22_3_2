import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wecode_2021/src/home_screen/home_screen_view.dart';
import 'package:wecode_2021/src/services/auth_service.dart';
import 'package:wecode_2021/src/trainers_screen/trainers_screen_view.dart';

class AuthHandler extends StatelessWidget {
  AuthHandler({Key? key}) : super(key: key);

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService.authStatusChanges,
      builder: (context, snapshot) {
        //todo if the user is logged in return the Dashboard
        if (!snapshot.hasData) {
          return HomeScreenView();
        }
        return TrainersScreenView();
        //todo if the user is'nt logged in return the HomeScreen
      },
    );
  }
}

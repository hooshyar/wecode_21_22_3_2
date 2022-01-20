import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wecode_2021/src/home_screen/home_screen_view.dart';
import 'package:wecode_2021/src/profile_screens/create_profile_screen.dart';
import 'package:wecode_2021/src/services/auth_service.dart';
import 'package:wecode_2021/src/student_screen/student_screen_view.dart';
import 'package:wecode_2021/src/trainers_screen/trainers_screen_view.dart';

class AuthHandler extends StatelessWidget {
  AuthHandler({Key? key}) : super(key: key);

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    //todo get the value of the current user

    //if the user exists in the database(using uid) =>
    //if the user exists in the database but the isCompletedProfile != true ? return the create profile

    //else if the user isTeacher == true return the teacherScreen

    // else return the students screen

    //if user doesnt exist in the database => return create profile screem

    User? user = Provider.of<AuthService>(context, listen: true)
        .theUser; //firebase auth user

    //checking with the firebase auth service for user
    if (user != null) {
      return Scaffold(
        backgroundColor: Colors.amber,
        // appBar: AppBar(title: Text('AuthHandler'), actions: [
        //   IconButton(
        //       onPressed: () {
        //         Provider.of<AuthService>(context, listen: false).logOut();
        //       },
        //       icon: Icon(Icons.logout)),
        // ]),
        body: FutureBuilder(
          future: Provider.of<AuthService>(context, listen: false)
              .fetchUserInfo(user.uid),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else if (snapshot.data == null) {
              return Text('empty');
            } else if (snapshot.data == false) {
              return CreateProfileScreen();
            } else if (snapshot.data == true &&
                Provider.of<AuthService>(context)
                        .generalUser!
                        .isCompletedProfile ==
                    false) {
              return CreateProfileScreen();
            } else if (snapshot.data == true &&
                Provider.of<AuthService>(context)
                        .generalUser!
                        .isCompletedProfile ==
                    true) {
              //is teacher  or is student
              if (Provider.of<AuthService>(context).generalUser!.isTeacher ==
                  true) {
                // return Text('66');
                return TrainersScreenView(); // change it to trainer
              } else {
                // return Text('69');
                return StudentScreen();
              }
            }

            return StudentScreen();
          },
        ),
      );
    } else {
      return HomeScreenView(); //main screen for non authenticates users
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wecode_2021/src/providers/nameProvider.dart';
import 'package:wecode_2021/src/services/auth_service.dart';

class HomeScreenView extends StatelessWidget {
  HomeScreenView({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // StreamBuilder<User?>(
            //     stream: _auth.authStatusChanges,
            //     builder: (context, snapshot) {
            //       if (snapshot.hasData) {
            //         return Text('the user is ${snapshot.data!.email} ');
            //       } else {
            //         return Text('no User');
            //       }
            //     }),

            Text(Provider.of<AuthService>(context, listen: true).theUser != null
                ? Provider.of<AuthService>(context, listen: true)
                    .theUser!
                    .email!
                : 'no user'),

            Divider(
              color: Colors.indigo,
              height: 25,
            ),

            // show this only to not logged in users
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text('Login')),
                  ),
                  VerticalDivider(width: 15),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text('register')),
                  ),
                ],
              ),
            ),

            //show this only to logged in users

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                        ),
                        onPressed: () {
                          Provider.of<AuthService>(context, listen: false)
                              .logOut();
                        },
                        child: Text('Sign Out')),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // String wait3Seconds(){
  //   // await Future.delayed(Duration(seconds: 3));
  //   return 'value recieved';
  // }
}

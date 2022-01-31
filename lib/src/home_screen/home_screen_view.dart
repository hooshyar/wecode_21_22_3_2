import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wecode_2021/src/services/auth_service.dart';

class HomeScreenView extends StatelessWidget {
  HomeScreenView({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple[400],

      
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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


            // show this only to not logged in users
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                          primary: Colors.deepPurple,
                        
                      ) ,
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text('Login')),
                  ),
                  VerticalDivider(width: 15),
                  Expanded(
                    child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                          primary: Colors.deepPurple,
                        
                      ) ,
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text('register')),
                  ),
                ],
              ),
            ),

            Provider.of<AuthService>(context).theUser == null
                ? Container()
                :
                // to create a profile
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.amber,
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed('/createProfileScreen');
                              },
                              child: Text('Create Profile')),
                        ),
                      ],
                    ),
                  ),

            //show this only to logged in users
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       Expanded(
            //         child: ElevatedButton(
                      
            //             style: ElevatedButton.styleFrom(
            //               primary: Colors.deepPurple,
            //             ),
            //             onPressed: () {
            //               Provider.of<AuthService>(context, listen: false)
            //                   .logOut();
            //             },
            //             child: Text('Sign Out')),
            //       ),
            //     ],
            //   ),
            // )
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

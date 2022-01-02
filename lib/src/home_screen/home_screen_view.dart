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
            //the provider part
            Text(
              'Welcome ${Provider.of<TheNameProvider>(context).name}',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300),
            ),

            StreamBuilder(
                stream: _auth.authStatusChanges,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text('the user is ${snapshot.data} ');
                  } else {
                    return Text('no User');
                  }
                }),
            Divider(
              color: Colors.indigo,
              height: 25,
            ),
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

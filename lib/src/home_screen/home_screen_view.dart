import 'package:flutter/material.dart';

class HomeScreenView extends StatelessWidget {
  const HomeScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Welcome',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300),
            ),
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

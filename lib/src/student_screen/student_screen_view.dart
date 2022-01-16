import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wecode_2021/src/services/auth_service.dart';

class StudentScreen extends StatelessWidget {
  const StudentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AuthHandler'), actions: [
        IconButton(
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).logOut();
            },
            icon: Icon(Icons.logout)),
      ]),
      body: Center(
        child: Text('student screen'),
      ),
    );
  }
}

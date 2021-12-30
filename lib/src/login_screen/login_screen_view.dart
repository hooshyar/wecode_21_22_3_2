import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wecode_2021/src/constants/style.dart';
import 'package:wecode_2021/src/trainers_screen/trainers_screen_view.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String name = 'user name';
  String? password;

  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          children: [
            Text('Welcome $name'),
            Form(
                child: Column(
              children: [
                //user name
                TextFormField(
                  controller: userNameController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: generalInputDecoration(
                      labelText: 'User Name', hintText: 'email@something.com'),
                ),
                //passsword

                SizedBox(height: 15),

                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: generalInputDecoration(labelText: 'Password'),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    setState(() {
                      name = userNameController.value.text;
                      password = passwordController.value.text;
                    });
                    name = name.trim(); //remove spaces
                    name = name.toLowerCase(); //convert to lowercase

                    //Basic auth using email and password

                    // await FirebaseAuth.instance
                    //     .createUserWithEmailAndPassword(
                    //         email: name, password: password!)
                    //     .then((value) {
                    //   debugPrint('=========> user id: ' + value.user!.uid);
                    // });
                  },
                  icon: Icon(
                    Icons.login,
                  ),
                  label: Text('Sign up'),
                ),
                SizedBox(
                  height: 50,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/privacyPolicyScreen');
                    },
                    child: Text('Privacy Policy'))
              ],
            ))
          ],
        ),
      ),
    );
  }
}

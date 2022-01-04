import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wecode_2021/src/constants/style.dart';
import 'package:wecode_2021/src/providers/nameProvider.dart';
import 'package:wecode_2021/src/services/auth_service.dart';
import 'package:wecode_2021/src/trainers_screen/trainers_screen_view.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String name = 'user name';
  String? password;

  TextEditingController _userNameController = TextEditingController();
  TextEditingController _theProviderTestController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registeration'),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          children: [
            Form(
                child: Column(
              children: [
                //user name
                TextFormField(
                  controller: _userNameController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: generalInputDecoration(
                      labelText: 'User Name', hintText: 'email@something.com'),
                ),
                //passsword

                SizedBox(height: 15),

                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: generalInputDecoration(labelText: 'Password'),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    setState(() {
                      name = _userNameController.value.text;
                      password = _passwordController.value.text;
                    });
                    name = name.trim(); //remove spaces
                    name = name.toLowerCase(); //convert to lowercase
                    await Provider.of<AuthService>(context, listen: false)
                        .registerWithEmailAndPassword(name, password!);
                    Navigator.pop(context); //pop the current screen
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
                    child: Text('Privacy Policy')),

                //user name

                TextFormField(
                  controller: _theProviderTestController,
                  decoration: generalInputDecoration(labelText: 'Name'),
                ),

                //the provider part
                Text(
                  'Welcome ${Provider.of<TheNameProvider>(context, listen: false).name}',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300),
                ),

                ElevatedButton(
                    onPressed: () {
                      Provider.of<TheNameProvider>(context, listen: false)
                          .changeTheName(_theProviderTestController.value.text);
                    },
                    child: Text('change the provider value'))
              ],
            ))
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wecode_2021/src/constants/style.dart';
import 'package:wecode_2021/src/services/auth_service.dart';

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
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registeration'),
        centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
         actions: <Widget>[
         Padding(
           padding: const EdgeInsets.all(10.0),
           child: IconButton(onPressed: () {
             Get.isDarkMode 
             ? Get.changeTheme(ThemeData.light()) : Get.changeTheme(ThemeData.dark());
           }, icon: Icon(Get.isDarkMode? Icons.mode_night: Icons.brightness_7), color: Colors.white,),
         ),
         ]
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
                //error
                Provider.of<AuthService>(context).theError == null
                    ? Container()
                    : Container(
                        child: Text(
                          Provider.of<AuthService>(context).theError!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                SizedBox(
                  height: 50,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/privacyPolicyScreen');
                    },
                    child: Text('Privacy Policy')),
              ],
            ))
          ],
        ),
      ),
    );
  }
}

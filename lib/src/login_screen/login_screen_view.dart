import 'package:flutter/material.dart';
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
      body: Column(
        children: [
          Text('Welcome $name'),
          Form(
              child: Column(
            children: [
              //user name
              TextFormField(
                controller: userNameController,
                keyboardType: TextInputType.emailAddress,
              ),

              //passsword
              TextFormField(
                controller: passwordController,
                obscureText: true,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    name = userNameController.value.text;
                    password = passwordController.value.text;
                  });
                  name = name.trim(); //remove spaces
                  name = name.toLowerCase(); //convert to lowercase

                  if (name == 'hooshyar' && password == 'another') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TrainersScreenView(
                          userName: name,
                          password: password,
                        ),
                      ),
                    );
                  }
                },
                icon: Icon(
                  Icons.login,
                ),
                label: Text('Login'),
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
    );
  }
}

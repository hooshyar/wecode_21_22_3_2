import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wecode_2021/src/constants/style.dart';
import 'package:wecode_2021/src/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String name = 'user name';
  String? password;
  String? theLoggedInUser;

  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Text('Welcome $name'),
              Form(
                  child: Column(
                children: [
                  // Text('the logged in user: $theLoggedInUser'),
        
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

                   SizedBox(
                    height: 150,
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
                          .loginWithEmailAndPassword(name, password!)
                          .then((value) {
                        setState(() {
                          theLoggedInUser = value!.user!.uid;
                        });
                        Navigator.pop(context);
                      });
                    },
                    icon: Icon(
                      Icons.login,
                    ),
                    label: Text(
                      'Login',
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple,
                    ),
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
                  // SizedBox(
                  //   height: 50,
                  // ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/privacyPolicyScreen');
                      },
                      child: Text('Privacy Policy'),
                      style: TextButton.styleFrom(
                        primary: Colors.deepPurple
                      ),
                      )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}

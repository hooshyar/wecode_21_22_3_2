import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.ac_unit,
              size: 32,
              color: Colors.blue,
            ),
            Text('some text'),
            Text('some text'),
            Text('some text'),
            Text('some text'),
            Text('some text'),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wecode_2021/src/data_models/general_user.dart';
import 'package:wecode_2021/src/jobs_screen/jobs_board_screen.dart';
import 'package:wecode_2021/src/services/auth_service.dart';
import 'package:wecode_2021/src/services/firestore_service.dart';
import 'package:wecode_2021/src/student_screen/student_linktree_view.dart';
import 'package:wecode_2021/src/student_screen/student_screen_view.dart';

class TrainersScreenView extends StatefulWidget {
  TrainersScreenView({Key? key}) : super(key: key);

  @override
  State<TrainersScreenView> createState() => _TrainersScreenViewState();
}

class _TrainersScreenViewState extends State<TrainersScreenView> {
  @override
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trainer Dashboard'), 
        centerTitle: true,
        backgroundColor: Colors.deepPurple[400],

        actions: [
        IconButton(
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).logOut();
            },
            icon: Icon(Icons.logout)
            ),
      ]),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => job_screen(),
                  ),
                );
              },
              child: Text('to the jobs board'),

              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurple,
              ),
              ),

              ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentLinktreeView(),
                  ),
                );
              },
              child: Text('Student Linktree'),

              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurple,
              ),
              ),

        ]
    ),
    );
  }

}

  
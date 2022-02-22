import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wecode_2021/src/data_models/general_user.dart';
import 'package:wecode_2021/src/jobs_screen/jobs_board_screen.dart';
import 'package:wecode_2021/src/profile_screens/create_profile_screen.dart';
import 'package:wecode_2021/src/services/auth_service.dart';
import 'package:wecode_2021/src/services/firestore_service.dart';
import 'package:wecode_2021/src/student_screen/student_linktree_view.dart';
import 'package:wecode_2021/src/student_screen/news_student_screen.dart';
import 'package:wecode_2021/src/trainers_screen/trainers_job_view.dart';
import 'package:wecode_2021/src/trainers_screen/trainers_list_of_news.dart';
import 'package:wecode_2021/src/trainers_screen/trainers_list_of_students.dart';

class TrainersScreenView extends StatefulWidget {
  TrainersScreenView({Key? key}) : super(key: key);

  @override
  State<TrainersScreenView> createState() => _TrainersScreenViewState();
}

class _TrainersScreenViewState extends State<TrainersScreenView> {
  @override
  int _currentIndex = 0;

  List<Widget> _screens = [
    TrainersListOfStudentsScreen(),
    TrainersListOfJobsScreen(),
    TrainersListOfNewsScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trainer Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple[400],
      ),
      drawer: Drawer(
        child: ListView(children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: new CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://images.unsplash.com/photo-1551847812-f815b31ae67c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=464&q=80"),
            ),
            accountName: Text("Trainer Name"),
            accountEmail: Text("Trainer@gmail.com"),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
          ),
          ListTile(
            title: Text("Home"),
            leading: Icon(Icons.home),
            onTap: () {},
          ),
          ListTile(
            title: Text("Edit Profile"),
            leading: Icon(Icons.edit),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateProfileScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: Text("Logout"),
            leading: Icon(Icons.logout),
            onTap: () {
              Provider.of<AuthService>(context, listen: false).logOut();
            },
          )
        ]),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) => setState(() {
          _currentIndex = value;
        }),
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Students',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cases),
            label: 'Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'News',
          ),
        ],
      ),
    );
  }
}

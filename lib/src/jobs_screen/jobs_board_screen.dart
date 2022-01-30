import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wecode_2021/src/data_models/job_model.dart';
import 'package:wecode_2021/src/jobs_screen/add_new_job_screen.dart';
import 'package:wecode_2021/src/jobs_screen/favourite_job_screen.dart';
import 'package:wecode_2021/src/jobs_screen/list_of_jobs_screen.dart';
import 'package:wecode_2021/src/services/firestore_service.dart';
import 'package:wecode_2021/src/widgets/jobs_card_widget.dart';

class job_screen extends StatefulWidget {
  const job_screen({Key? key}) : super(key: key);

  @override
  _job_screenState createState() => _job_screenState();
}

class _job_screenState extends State<job_screen> {
  int _currentIndex = 0;
  List<Widget> _screens = [ListOfJobsScreen(), FavouriteJobScreen()];
  //todo list of screens here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (_tappedIndex) {
          setState(() {
            _currentIndex = _tappedIndex;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'List',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Fav',
            backgroundColor: Colors.green,
          ),
        ],
      ),
    );
  }
}

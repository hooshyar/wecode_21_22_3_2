import 'package:flutter/material.dart';
import 'package:wecode_2021/src/jobs_screen/jobs_board_screen.dart';
import 'package:wecode_2021/src/student_screen/student_linktree_view.dart';

class TrainersListOfStudentsScreen extends StatelessWidget {
  const TrainersListOfStudentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StudentLinktreeView();
    // return Container(
    //   child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       crossAxisAlignment: CrossAxisAlignment.stretch,
    //       children: [
    //         ElevatedButton(
    //           onPressed: () {
    //             Navigator.push(
    //               context,
    //               MaterialPageRoute(
    //                 builder: (context) => JobScreen(),
    //               ),
    //             );
    //           },
    //           child: Text('to the jobs board'),
    //           style: ElevatedButton.styleFrom(
    //             primary: mainColor
    //           ),
    //         ),
    //         ElevatedButton(
    //           onPressed: () {
    //             Navigator.push(
    //               context,
    //               MaterialPageRoute(
    //                 builder: (context) => StudentLinktreeView(),
    //               ),
    //             );
    //           },
    //           child: Text('Student Linktree'),
    //           style: ElevatedButton.styleFrom(
    //             primary: mainColor
    //           ),
    //         ),
    //       ]),
    // );
  }
}

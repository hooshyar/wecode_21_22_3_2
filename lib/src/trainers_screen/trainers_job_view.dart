import 'package:flutter/material.dart';
import 'package:wecode_2021/src/jobs_screen/list_of_jobs_screen.dart';

class TrainersListOfJobsScreen extends StatelessWidget {
  const TrainersListOfJobsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListOfJobsScreen(),
    );
  }
}

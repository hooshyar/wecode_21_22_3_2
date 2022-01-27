import 'package:flutter/material.dart';
import 'package:wecode_2021/src/data_models/job_model.dart';

class JobCardWidget extends StatelessWidget {
  final Job job;
  const JobCardWidget({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListTile(
          title: Text(job.jobTitle),
          subtitle: Text(job.jobDesc),
          trailing: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text('likes'),
                Text(job.jobLikeCount.toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:wecode_2021/src/data_models/job_model.dart';
import 'package:wecode_2021/src/services/firestore_service.dart';
import 'package:wecode_2021/src/widgets/jobs_card_widget.dart';

class job_screen extends StatefulWidget {
  const job_screen({Key? key}) : super(key: key);

  @override
  _job_screenState createState() => _job_screenState();
}

class _job_screenState extends State<job_screen> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            child: Row(
              children: [
                Container(
                  color: Colors.red,
                )
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Job>>(
                stream: _firestoreService.streamOfJobs(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return LinearProgressIndicator();
                  else if (snapshot.hasError)
                    return Center(child: Text('error ${snapshot.error}'));
                  else if (snapshot.data!.isEmpty) {
                    return Center(child: Text('no job available'));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return JobCardWidget(job: snapshot.data![index]);
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}

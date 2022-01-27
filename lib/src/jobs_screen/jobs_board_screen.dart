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

  
  TextEditingController job_title_Controller = TextEditingController();
  TextEditingController category_Controller = TextEditingController();
  TextEditingController company_name_Controller = TextEditingController();
  TextEditingController job_desc_Controller = TextEditingController();
  TextEditingController hires_times_Controller = TextEditingController();
  TextEditingController salary_Controller = TextEditingController();
  TextEditingController date_valid_Controller = TextEditingController();
  TextEditingController send_cv_Controller = TextEditingController();

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

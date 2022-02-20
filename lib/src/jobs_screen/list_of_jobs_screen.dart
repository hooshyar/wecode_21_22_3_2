import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wecode_2021/src/data_models/job_model.dart';
import 'package:wecode_2021/src/jobs_screen/add_new_job_screen.dart';
import 'package:wecode_2021/src/services/auth_service.dart';
import 'package:wecode_2021/src/services/firestore_service.dart';
import 'package:wecode_2021/src/widgets/jobs_card_widget.dart';

class ListOfJobsScreen extends StatefulWidget {
  const ListOfJobsScreen({Key? key}) : super(key: key);

  @override
  _ListOfJobsScreenState createState() => _ListOfJobsScreenState();
}

class _ListOfJobsScreenState extends State<ListOfJobsScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Widget> _screens = [];
  //todo list of screens here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
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
                      return Container(
                          height: 100,
                          child: JobCardWidget(job: snapshot.data![index]));
                    },
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: Provider.of<AuthService>(context).generalUser!.isTeacher! ?  FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          child: FaIcon(FontAwesomeIcons.plus),
          onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NewJobScreen()),
              )
              
              ) : Container(),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wecode_2021/src/data_models/job_model.dart';
import 'package:wecode_2021/src/jobs_screen/add_new_job_screen.dart';
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
      appBar: AppBar(
        title: Text("Job Board"),
        centerTitle: true,
        backgroundColor: Colors.grey,
      ),
      

      body: Column(
        children: [
          Container(
            
            height: 100,
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
                      return Container(
                          height: 100,
                          child: JobCardWidget(job: snapshot.data![index]));
                    },
                  );
                }),
          ),
        ],
      ),

         floatingActionButton: FloatingActionButton(
           backgroundColor:Colors.black,
         child: FaIcon(FontAwesomeIcons.plus),
         onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NewJobScreen()),
              )),

        bottomNavigationBar: BottomNavigationBar(
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

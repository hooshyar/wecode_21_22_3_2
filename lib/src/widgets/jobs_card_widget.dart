import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wecode_2021/src/data_models/job_model.dart';
import 'package:wecode_2021/src/services/auth_service.dart';

class JobCardWidget extends StatelessWidget {
  final Job job;
  JobCardWidget({Key? key, required this.job}) : super(key: key);

  //to have access to our database
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListTile(
          title: Text(job.jobTitle),
          subtitle: Text(job.jobDesc),
          trailing: Container(
            padding: EdgeInsets.all(10),
            child: Container(
              width: 150,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () async {
                        // to find the user in users collection
                        String? _theUID =
                            Provider.of<AuthService>(context, listen: false)
                                .generalUser!
                                .uid;

                        debugPrint("the uid: $_theUID");

                        // add the job to the favs collection
                        await _firebaseFirestore
                            .collection('users')
                            .doc(_theUID)
                            .collection('favs')
                            .add(job.toMap());

                        // set/add
                      },
                      icon: FaIcon(FontAwesomeIcons.heart)),
                  Expanded(
                    child: Column(
                      children: [
                        Text('likes'),
                        Text(job.jobLikeCount.toString()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wecode_2021/src/data_models/general_user.dart';
import 'package:wecode_2021/src/data_models/job_model.dart';

class FirestoreService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> incrementTheLikesValue(
      int likesCount, DocumentReference doc) async {
    await doc.update({'jobLikeCount': likesCount++}).then((value) {
      return debugPrint('success');
    }).onError((error, stackTrace) => debugPrint(error.toString()));
  }

  Future<void> incrementTheViewCount(
      int jobViews, DocumentReference doc) async {
    await doc.update({'jobViews': jobViews++}).then((value) {
      return debugPrint('success');
    }).onError((error, stackTrace) => debugPrint(error.toString()));
  }

//read a stream of jobs to the screen
  Stream<List<Job>> streamOfJobs() {
    return _firebaseFirestore.collection('jobs').snapshots().map(
          (v) => v.docs
              .map(
                (e) => Job.fromMap(e.data()),
              )
              .toList(),
        );
  }

  //adding a new job to firestore "jobs" collection
  Future<void> addNewJob(Job job) async {
    await _firebaseFirestore
        .collection('jobs')
        .add(job.toMap())
        .then((value) => debugPrint('success'))
        .onError((error, stackTrace) => debugPrint(error.toString()));
  }

  Stream<List<GeneralUser>>? streamOfGeneralUsers(
      {String? name, String? sortby}) {
    String? fieldName;

    if (sortby == 'date') fieldName = 'createdAt';
    if (sortby == 'bootcamp name') fieldName = 'bootCampName';

    return _firebaseFirestore
        .collection('users')
        .where('name', isEqualTo: name)
        .where('isTeacher', isEqualTo: true)
        // .orderBy('createdAt')
        // .where('bootcamp', isEqualTo: 'MA') show the students for correct bootcamp ID
        //todo : update the registration form to select the bootcamp name using a drop down

        .snapshots()
        .map(
          (docValue) => docValue.docs
              .map(
                (e) => GeneralUser.fromMap(
                  e.data(),
                ),
              )
              .toList(),
        );
  }
}

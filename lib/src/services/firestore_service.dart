import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wecode_2021/src/data_models/general_user.dart';

class FirestoreService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

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

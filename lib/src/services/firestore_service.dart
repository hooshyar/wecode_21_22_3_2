import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wecode_2021/src/data_models/general_user.dart';

class FirestoreService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Stream<List<GeneralUser>>? streamOfGeneralUsers(
      {String? name, String? sortby}) {
    String? fieldName;

    if (sortby == 'date') fieldName = 'createdAt';
    if (sortby == 'bootcamp name') fieldName = 'bootCampName';

    if (sortby == null) {
      if (name != null) {
        return _firebaseFirestore
            .collection('users')
            .where('name', isEqualTo: name)
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
      return _firebaseFirestore
          .collection('users')
          // .where('name', isEqualTo: name)
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
    } else {
      if (name != null) {
        return _firebaseFirestore
            .collection('users')
            .where('name', isEqualTo: name)
            .orderBy(fieldName!)
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
      return _firebaseFirestore
          .collection('users')
          // .where('name', isEqualTo: name)
          .orderBy(fieldName!, descending: true)
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
}

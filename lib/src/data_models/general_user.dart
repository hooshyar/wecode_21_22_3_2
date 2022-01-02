import 'package:cloud_firestore/cloud_firestore.dart';

class GeneralUser {
  String? name;
  String? uid; // the uid from firebase auth service
  String? email;
  String? github;
  String? stackOverflow;
  int? points;
  int? thumbsUps;
  String? imgUrl;
  String? phoneNumber;
  bool? isTeacher; //if it is a teacher
  bool? isAdmin; //if it is an Admin
  Timestamp? createdAt;
  Timestamp? updatedAt;
  String? bootCampId;
  String? bootCampName;

  GeneralUser(
      {this.uid,
      this.name,
      this.email,
      this.bootCampId,
      this.bootCampName,
      this.createdAt,
      this.github,
      this.imgUrl,
      this.isAdmin,
      this.isTeacher,
      this.phoneNumber,
      this.points,
      this.stackOverflow,
      this.thumbsUps,
      this.updatedAt});
}

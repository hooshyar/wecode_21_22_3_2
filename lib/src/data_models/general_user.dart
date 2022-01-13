import 'package:cloud_firestore/cloud_firestore.dart';

class GeneralUser {
  String? name;
  String? uid; // the uid from firebase auth service
  String? email;
  String? github;
  String? stackOverflow;
  String? linkedIn;
  int? points;
  int? thumbsUps;
  String? imgUrl; // Firebase Storage
  String? phoneNumber;
  bool? isTeacher; //if it is a teacher
  bool? isAdmin; //if it is an Admin
  bool? isCompletedProfile; //if the user completed the profile
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
      this.linkedIn,
      this.stackOverflow,
      this.thumbsUps,
      this.isCompletedProfile,
      this.updatedAt});

  // from map which reads the data from the database

  factory GeneralUser.fromMap(Map<String, dynamic> json) => GeneralUser(
      uid: json["uid"],
      name: json["name"],
      email: json["email"],
      bootCampId: json["bootCampId"],
      bootCampName: json["bootCampName"],
      createdAt: json["createdAt"],
      github: json["github"],
      imgUrl: json["imgUrl"],
      isAdmin: json["isAdmin"],
      isTeacher: json["isTeacher"],
      phoneNumber: json["phoneNumber"],
      points: json["points"],
      stackOverflow: json["stackOverflow"],
      linkedIn: json["linkedIn"],
      thumbsUps: json["thumbsUps"],
      isCompletedProfile: json["isCompletedProfile"],
      updatedAt: json["updatedAt"]);

  // toMap()
  Map<String, dynamic> toMap() => {
        "uid": uid,
        "name": name,
        "email": email,
        "bootCampId": bootCampId,
        "bootCampName": bootCampName,
        "createdAt": createdAt,
        "github": github,
        "imgUrl": imgUrl,
        "isAdmin": isAdmin,
        "isTeacher": isTeacher,
        "phoneNumber": phoneNumber,
        "points": points,
        "stackOverflow": stackOverflow,
        "linkedIn": linkedIn,
        "thumbsUps": thumbsUps,
        "isCompletedProfile":
            isCompletedProfile, // this has to be true when user completed their profile
        "updatedAt": updatedAt,
      };
}

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Job {
  String jobTitle;
  String jobDesc;
  Timestamp jobCreatedAt;
  Timestamp jobDueDate;
  String jobCategory;
  int jobHiresCount;
  num salaryEstimate;
  String companyName;
  num jobLikeCount;
  num jobViews;
  bool isFaved;
  String emailAddress;
  Job({
    required this.jobTitle,
    required this.jobDesc,
    required this.jobCreatedAt,
    required this.jobDueDate,
    required this.jobCategory,
    required this.jobHiresCount,
    required this.salaryEstimate,
    required this.companyName,
    required this.jobLikeCount,
    required this.jobViews,
    required this.isFaved,
    required this.emailAddress,
  });

  Job copyWith({
    String? jobTitle,
    String? jobDesc,
    Timestamp? jobCreatedAt,
    Timestamp? jobDueDate,
    String? jobCategory,
    int? jobHiresCount,
    num? salaryEstimate,
    String? companyName,
    num? jobLikeCount,
    num? jobViews,
    bool? isFaved,
    String? emailAddress,
  }) {
    return Job(
      jobTitle: jobTitle ?? this.jobTitle,
      jobDesc: jobDesc ?? this.jobDesc,
      jobCreatedAt: jobCreatedAt ?? this.jobCreatedAt,
      jobDueDate: jobDueDate ?? this.jobDueDate,
      jobCategory: jobCategory ?? this.jobCategory,
      jobHiresCount: jobHiresCount ?? this.jobHiresCount,
      salaryEstimate: salaryEstimate ?? this.salaryEstimate,
      companyName: companyName ?? this.companyName,
      jobLikeCount: jobLikeCount ?? this.jobLikeCount,
      jobViews: jobViews ?? this.jobViews,
      isFaved: isFaved ?? this.isFaved,
      emailAddress: emailAddress ?? this.emailAddress,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'jobTitle': jobTitle,
      'jobDesc': jobDesc,
      'jobCreatedAt': jobCreatedAt,
      'jobDueDate': jobDueDate,
      'jobCategory': jobCategory,
      'jobHiresCount': jobHiresCount,
      'salaryEstimate': salaryEstimate,
      'companyName': companyName,
      'jobLikeCount': jobLikeCount,
      'jobViews': jobViews,
      'isFaved': isFaved,
      'emailAddress': emailAddress,
    };
  }

  factory Job.fromMap(Map<String, dynamic> map) {
    return Job(
      jobTitle: map['jobTitle'] ?? '',
      jobDesc: map['jobDesc'] ?? '',
      jobCreatedAt: map['jobCreatedAt'],
      jobDueDate: map['jobDueDate'],
      jobCategory: map['jobCategory'] ?? '',
      jobHiresCount: map['jobHiresCount']?.toInt() ?? 0,
      salaryEstimate: map['salaryEstimate'] ?? 0,
      companyName: map['companyName'] ?? '',
      jobLikeCount: map['jobLikeCount'] ?? 0,
      jobViews: map['jobViews'] ?? 0,
      isFaved: map['isFaved'] ?? false,
      emailAddress: map['emailAddress'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Job.fromJson(String source) => Job.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Job(jobTitle: $jobTitle, jobDesc: $jobDesc, jobCreatedAt: $jobCreatedAt, jobDueDate: $jobDueDate, jobCategory: $jobCategory, jobHiresCount: $jobHiresCount, salaryEstimate: $salaryEstimate, companyName: $companyName, jobLikeCount: $jobLikeCount, jobViews: $jobViews, isFaved: $isFaved, emailAddress: $emailAddress)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Job &&
        other.jobTitle == jobTitle &&
        other.jobDesc == jobDesc &&
        other.jobCreatedAt == jobCreatedAt &&
        other.jobDueDate == jobDueDate &&
        other.jobCategory == jobCategory &&
        other.jobHiresCount == jobHiresCount &&
        other.salaryEstimate == salaryEstimate &&
        other.companyName == companyName &&
        other.jobLikeCount == jobLikeCount &&
        other.jobViews == jobViews &&
        other.isFaved == isFaved &&
        other.emailAddress == emailAddress;
  }

  @override
  int get hashCode {
    return jobTitle.hashCode ^
        jobDesc.hashCode ^
        jobCreatedAt.hashCode ^
        jobDueDate.hashCode ^
        jobCategory.hashCode ^
        jobHiresCount.hashCode ^
        salaryEstimate.hashCode ^
        companyName.hashCode ^
        jobLikeCount.hashCode ^
        jobViews.hashCode ^
        isFaved.hashCode ^
        emailAddress.hashCode;
  }
}

import 'dart:convert';

class Job {
  String jobTitle;
  String jobDesc;
  String jobCreatedAt;
  String jobDueDate;
  String jobCategory;
  String jobHiresCount;
  num salaryEstimate;
  String companyName;
  num jobLikeCount;
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
    required this.emailAddress,
  });

  Job copyWith({
    String? jobTitle,
    String? jobDesc,
    String? jobCreatedAt,
    String? jobDueDate,
    String? jobCategory,
    String? jobHiresCount,
    num? salaryEstimate,
    String? companyName,
    num? jobLikeCount,
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
      'emailAddress': emailAddress,
    };
  }

  factory Job.fromMap(Map<String, dynamic> map) {
    return Job(
      jobTitle: map['jobTitle'] ?? '',
      jobDesc: map['jobDesc'] ?? '',
      jobCreatedAt: map['jobCreatedAt'] ?? '',
      jobDueDate: map['jobDueDate'] ?? '',
      jobCategory: map['jobCategory'] ?? '',
      jobHiresCount: map['jobHiresCount'] ?? '',
      salaryEstimate: map['salaryEstimate'] ?? 0,
      companyName: map['companyName'] ?? '',
      jobLikeCount: map['jobLikeCount'] ?? 0,
      emailAddress: map['emailAddress'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Job.fromJson(String source) => Job.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Job(jobTitle: $jobTitle, jobDesc: $jobDesc, jobCreatedAt: $jobCreatedAt, jobDueDate: $jobDueDate, jobCategory: $jobCategory, jobHiresCount: $jobHiresCount, salaryEstimate: $salaryEstimate, companyName: $companyName, jobLikeCount: $jobLikeCount, emailAddress: $emailAddress)';
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
        emailAddress.hashCode;
  }
}

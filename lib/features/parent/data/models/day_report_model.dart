import 'package:coleapp/features/parent/data/models/student_model.dart';

class DayReportModel {
  final ReportStudent student;
  final List<AttendanceModel> attendances;

  DayReportModel({required this.student, required this.attendances});

  factory DayReportModel.fromJson(Map<String, dynamic> json) => DayReportModel(
    student: ReportStudent.fromJson(json['student'] as Map<String, dynamic>),
    attendances: (json['attendances'] as List)
        .map((e) => AttendanceModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

class ReportStudent {
  final int id;
  final String code;
  final String name;
  final String lastName;
  final String birthDate;
  final String sex;
  final String? email;
  final bool status;
  final StudentLevel level;
  final StudentGrade grade;
  final StudentSection section;

  ReportStudent({
    required this.id,
    required this.code,
    required this.name,
    required this.lastName,
    required this.birthDate,
    required this.sex,
    this.email,
    required this.status,
    required this.level,
    required this.grade,
    required this.section,
  });

  factory ReportStudent.fromJson(Map<String, dynamic> json) => ReportStudent(
    id: json['id'] as int,
    code: json['code'] as String,
    name: json['name'] as String,
    lastName: json['lastName'] as String,
    birthDate: json['birthDate'] as String,
    sex: json['sex'] as String,
    email: json['email'] as String?,
    status: json['status'] as bool,
    level: StudentLevel.fromJson(json['level'] as Map<String, dynamic>),
    grade: StudentGrade.fromJson(json['grade'] as Map<String, dynamic>),
    section: StudentSection.fromJson(json['section'] as Map<String, dynamic>),
  );

  String get fullName => '$name $lastName';
}

class AttendanceModel {
  final String id;
  final String date;
  final String? checkInTime;
  final String? checkOutTime;
  final bool updatedInClass;
  final String behaviorStatus;
  final String statusCheckIn;
  final String statusCheckOut;
  final String? justification;

  AttendanceModel({
    required this.id,
    required this.date,
    this.checkInTime,
    this.checkOutTime,
    required this.updatedInClass,
    required this.behaviorStatus,
    required this.statusCheckIn,
    required this.statusCheckOut,
    this.justification,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) => AttendanceModel(
    id: json['id'] as String,
    date: json['date'] as String,
    checkInTime: json['checkInTime'] as String?,
    checkOutTime: json['checkOutTime'] as String?,
    updatedInClass: json['updatedInClass'] as bool,
    behaviorStatus: json['behaviorStatus'] as String,
    statusCheckIn: json['statusCheckIn'] as String,
    statusCheckOut: json['statusCheckOut'] as String,
    justification: json['justification'] as String?,
  );
}

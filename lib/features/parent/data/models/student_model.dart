import 'package:equatable/equatable.dart';

class StudentLevel {
  final int id;
  final String name;
  final String entryTime;
  final String exitTime;
  final int toleranceTime;
  final bool status;

  StudentLevel({
    required this.id,
    required this.name,
    required this.entryTime,
    required this.exitTime,
    required this.toleranceTime,
    required this.status,
  });

  factory StudentLevel.fromJson(Map<String, dynamic> json) => StudentLevel(
    id: json['id'] as int,
    name: json['name'] as String,
    entryTime: json['entryTime'] as String,
    exitTime: json['exitTime'] as String,
    toleranceTime: json['toleranceTime'] as int,
    status: json['status'] as bool,
  );
}

class StudentGrade {
  final int id;
  final String name;
  final bool status;

  StudentGrade({required this.id, required this.name, required this.status});

  factory StudentGrade.fromJson(Map<String, dynamic> json) => StudentGrade(
    id: json['id'] as int,
    name: json['name'] as String,
    status: json['status'] as bool,
  );
}

class StudentSection {
  final int id;
  final String name;
  final bool status;

  StudentSection({required this.id, required this.name, required this.status});

  factory StudentSection.fromJson(Map<String, dynamic> json) => StudentSection(
    id: json['id'] as int,
    name: json['name'] as String,
    status: json['status'] as bool,
  );
}

class StudentModel extends Equatable {
  final int id;
  final String code;
  final String name;
  final String lastName;
  final String? birthDate;
  final String sex;
  final String? email;
  final bool sendWhatsapp;
  final bool status;
  final bool isShowQr;
  final StudentLevel level;
  final StudentGrade grade;
  final StudentSection section;
  final String dni;
  final int parentsCount;

  const StudentModel({
    required this.id,
    required this.code,
    required this.name,
    required this.lastName,
    this.birthDate,
    required this.sex,
    this.email,
    required this.sendWhatsapp,
    required this.status,
    required this.isShowQr,
    required this.level,
    required this.grade,
    required this.section,
    required this.dni,
    required this.parentsCount,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) => StudentModel(
    id: json['id'] as int,
    code: json['code'] as String,
    name: json['name'] as String,
    lastName: json['lastName'] as String,
    birthDate: json['birthDate'] as String?,
    sex: json['sex'] as String,
    email: json['email'] as String?,
    sendWhatsapp: json['sendWhatsapp'] as bool,
    status: json['status'] as bool,
    isShowQr: json['isShowQr'] as bool,
    level: StudentLevel.fromJson(json['level'] as Map<String, dynamic>),
    grade: StudentGrade.fromJson(json['grade'] as Map<String, dynamic>),
    section: StudentSection.fromJson(json['section'] as Map<String, dynamic>),
    dni: json['dni'] as String,
    parentsCount: json['parentsCount'] as int,
  );

  String get fullName => '$name $lastName';

  @override
  List<Object?> get props => [id, code, name, lastName, dni];
}

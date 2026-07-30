class StudentGradeModel {
  final int id;
  final StudentInfo student;
  final double score;
  final String dateRecorded;
  final AssessmentDefinition assessmentDefinition;

  StudentGradeModel({
    required this.id,
    required this.student,
    required this.score,
    required this.dateRecorded,
    required this.assessmentDefinition,
  });

  factory StudentGradeModel.fromJson(Map<String, dynamic> json) => StudentGradeModel(
    id: json['id'] as int,
    student: StudentInfo.fromJson(json['student'] as Map<String, dynamic>),
    score: (json['score'] as num).toDouble(),
    dateRecorded: json['dateRecorded'] as String,
    assessmentDefinition: AssessmentDefinition.fromJson(
      json['assessmentDefinition'] as Map<String, dynamic>,
    ),
  );

  String get courseName => assessmentDefinition.assessmentSet.courseSection.course.name;
  String get setName => assessmentDefinition.assessmentSet.name;
  String get definitionName => assessmentDefinition.name;
}

class StudentInfo {
  final int id;

  StudentInfo({required this.id});

  factory StudentInfo.fromJson(Map<String, dynamic> json) => StudentInfo(
    id: json['id'] as int,
  );
}

class AssessmentDefinition {
  final int id;
  final String name;
  final double percentage;
  final double maxScore;
  final AssessmentSet assessmentSet;

  AssessmentDefinition({
    required this.id,
    required this.name,
    required this.percentage,
    required this.maxScore,
    required this.assessmentSet,
  });

  factory AssessmentDefinition.fromJson(Map<String, dynamic> json) => AssessmentDefinition(
    id: json['id'] as int,
    name: json['name'] as String,
    percentage: (json['percentage'] as num).toDouble(),
    maxScore: (json['maxScore'] as num).toDouble(),
    assessmentSet: AssessmentSet.fromJson(json['assessmentSet'] as Map<String, dynamic>),
  );
}

class AssessmentSet {
  final int id;
  final String name;
  final double percentage;
  final CourseSection courseSection;

  AssessmentSet({
    required this.id,
    required this.name,
    required this.percentage,
    required this.courseSection,
  });

  factory AssessmentSet.fromJson(Map<String, dynamic> json) => AssessmentSet(
    id: json['id'] as int,
    name: json['name'] as String,
    percentage: (json['percentage'] as num).toDouble(),
    courseSection: CourseSection.fromJson(json['courseSection'] as Map<String, dynamic>),
  );
}

class CourseSection {
  final int id;
  final Course course;

  CourseSection({required this.id, required this.course});

  factory CourseSection.fromJson(Map<String, dynamic> json) => CourseSection(
    id: json['id'] as int,
    course: Course.fromJson(json['course'] as Map<String, dynamic>),
  );
}

class Course {
  final int id;
  final String name;

  Course({required this.id, required this.name});

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    id: json['id'] as int,
    name: json['name'] as String,
  );
}

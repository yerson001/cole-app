class ScheduleModel {
  final int id;
  final TeacherCourseSection teacherCourseSection;
  final int day;
  final String startTime;
  final String endTime;
  final bool status;

  ScheduleModel({
    required this.id,
    required this.teacherCourseSection,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) => ScheduleModel(
    id: json['id'] as int,
    teacherCourseSection: TeacherCourseSection.fromJson(
      json['teacherCourseSection'] as Map<String, dynamic>,
    ),
    day: json['day'] as int,
    startTime: json['startTime'] as String,
    endTime: json['endTime'] as String,
    status: json['status'] as bool? ?? true,
  );

  String get timeRange => '${startTime.substring(0, 5)} - ${endTime.substring(0, 5)}';
  String get courseName => teacherCourseSection.courseSection.course.name;
  String get teacherName => teacherCourseSection.teacher.person.fullName;
  String get sectionName => teacherCourseSection.courseSection.section.name;
}

class TeacherCourseSection {
  final int id;
  final CourseSection courseSection;
  final Teacher teacher;
  final bool status;

  TeacherCourseSection({
    required this.id,
    required this.courseSection,
    required this.teacher,
    required this.status,
  });

  factory TeacherCourseSection.fromJson(Map<String, dynamic> json) => TeacherCourseSection(
    id: json['id'] as int,
    courseSection: CourseSection.fromJson(json['courseSection'] as Map<String, dynamic>),
    teacher: Teacher.fromJson(json['teacher'] as Map<String, dynamic>),
    status: json['status'] as bool? ?? true,
  );
}

class CourseSection {
  final int id;
  final Course course;
  final Section section;
  final bool status;

  CourseSection({
    required this.id,
    required this.course,
    required this.section,
    required this.status,
  });

  factory CourseSection.fromJson(Map<String, dynamic> json) => CourseSection(
    id: json['id'] as int,
    course: Course.fromJson(json['course'] as Map<String, dynamic>),
    section: Section.fromJson(json['section'] as Map<String, dynamic>),
    status: json['status'] as bool? ?? true,
  );
}

class Course {
  final int id;
  final String name;
  final bool status;

  Course({required this.id, required this.name, required this.status});

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    id: json['id'] as int,
    name: json['name'] as String,
    status: json['status'] as bool? ?? true,
  );
}

class Section {
  final int id;
  final String name;
  final bool status;

  Section({required this.id, required this.name, required this.status});

  factory Section.fromJson(Map<String, dynamic> json) => Section(
    id: json['id'] as int,
    name: json['name'] as String,
    status: json['status'] as bool? ?? true,
  );
}

class Teacher {
  final int id;
  final Person person;

  Teacher({required this.id, required this.person});

  factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
    id: json['id'] as int,
    person: Person.fromJson(json['person'] as Map<String, dynamic>),
  );
}

class Person {
  final int id;
  final String name;
  final String lastName;

  Person({required this.id, required this.name, required this.lastName});

  factory Person.fromJson(Map<String, dynamic> json) => Person(
    id: json['id'] as int,
    name: json['name'] as String,
    lastName: json['lastName'] as String,
  );

  String get fullName => '$name $lastName';
}

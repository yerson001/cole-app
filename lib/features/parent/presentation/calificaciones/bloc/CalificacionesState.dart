import 'package:equatable/equatable.dart';
import 'package:coleapp/features/parent/data/models/student_grade_model.dart';
import 'package:coleapp/features/parent/data/models/student_model.dart';

class CalificacionesState extends Equatable {
  final StudentModel? selectedStudent;
  final List<StudentGradeModel> grades;
  final bool isLoading;
  final String? error;
  final String tenantId;

  const CalificacionesState({
    this.selectedStudent,
    this.grades = const [],
    this.isLoading = false,
    this.error,
    this.tenantId = '',
  });

  CalificacionesState copyWith({
    StudentModel? selectedStudent,
    List<StudentGradeModel>? grades,
    bool? isLoading,
    String? error,
    String? tenantId,
    bool clearError = false,
  }) {
    return CalificacionesState(
      selectedStudent: selectedStudent ?? this.selectedStudent,
      grades: grades ?? this.grades,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      tenantId: tenantId ?? this.tenantId,
    );
  }

  Map<String, CourseGrades> get gradesByCourse {
    final map = <String, CourseGrades>{};
    for (final grade in grades) {
      final courseName = grade.courseName;
      map.putIfAbsent(courseName, () => CourseGrades(courseName: courseName));
      map[courseName]!.addGrade(grade);
    }
    return map;
  }

  @override
  List<Object?> get props => [selectedStudent, grades, isLoading, error, tenantId];
}

class CourseGrades {
  final String courseName;
  final Map<String, SetGrades> sets = {};

  CourseGrades({required this.courseName});

  void addGrade(StudentGradeModel grade) {
    final setName = grade.setName;
    sets.putIfAbsent(setName, () => SetGrades(name: setName, percentage: grade.assessmentDefinition.assessmentSet.percentage));
    sets[setName]!.addGrade(grade);
  }

  double get totalScore {
    double total = 0;
    for (final set in sets.values) {
      total += set.weightedScore;
    }
    return total;
  }
}

class SetGrades {
  final String name;
  final double percentage;
  final List<StudentGradeModel> grades = [];

  SetGrades({required this.name, required this.percentage});

  void addGrade(StudentGradeModel grade) {
    grades.add(grade);
  }

  double get weightedScore {
    double sum = 0;
    for (final grade in grades) {
      sum += grade.score * (grade.assessmentDefinition.percentage / 100);
    }
    return sum * (percentage / 100);
  }
}

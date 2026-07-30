import 'package:coleapp/features/parent/data/models/student_model.dart';

abstract class AsistenciaEvent {}

class InitializeAsistencia extends AsistenciaEvent {
  final String tenant;
  final int branchId;
  final List<StudentModel> students;
  final int? initialStudentId;
  InitializeAsistencia({
    required this.tenant,
    required this.branchId,
    required this.students,
    this.initialStudentId,
  });
}

class SelectStudent extends AsistenciaEvent {
  final StudentModel student;
  SelectStudent({required this.student});
}

class ChangeDate extends AsistenciaEvent {
  final DateTime date;
  ChangeDate({required this.date});
}

class ChangeMonth extends AsistenciaEvent {
  final DateTime month;
  ChangeMonth({required this.month});
}

class LoadDailyAttendance extends AsistenciaEvent {}

class LoadRangeAttendance extends AsistenciaEvent {}

class ReloadAll extends AsistenciaEvent {}

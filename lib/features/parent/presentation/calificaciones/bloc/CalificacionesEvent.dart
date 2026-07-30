import 'package:coleapp/features/parent/data/models/student_model.dart';

abstract class CalificacionesEvent {}

class LoadCalificaciones extends CalificacionesEvent {
  final StudentModel student;
  final String tenantId;

  LoadCalificaciones({required this.student, required this.tenantId});
}

class SelectStudent extends CalificacionesEvent {
  final StudentModel student;

  SelectStudent({required this.student});
}

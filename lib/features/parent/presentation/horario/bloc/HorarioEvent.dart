import 'package:coleapp/features/parent/data/models/student_model.dart';

abstract class HorarioEvent {}

class LoadHorario extends HorarioEvent {
  final StudentModel student;
  final String tenantId;

  LoadHorario({required this.student, required this.tenantId});
}

class SelectStudent extends HorarioEvent {
  final StudentModel student;

  SelectStudent({required this.student});
}

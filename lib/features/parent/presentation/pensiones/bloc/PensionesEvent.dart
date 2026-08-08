import 'package:coleapp/features/parent/data/models/student_model.dart';

abstract class PensionesEvent {}

class LoadPensiones extends PensionesEvent {
  final StudentModel student;
  final String tenantId;

  LoadPensiones({required this.student, required this.tenantId});
}

class SelectStudent extends PensionesEvent {
  final StudentModel student;

  SelectStudent({required this.student});
}

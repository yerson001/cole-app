import 'package:coleapp/features/parent/data/models/student_model.dart';

abstract class CuotasEvent {}

class LoadCuotas extends CuotasEvent {
  final StudentModel student;
  final String tenantId;

  LoadCuotas({required this.student, required this.tenantId});
}

class SelectStudent extends CuotasEvent {
  final StudentModel student;

  SelectStudent({required this.student});
}

import 'package:coleapp/features/parent/data/models/student_model.dart';
import 'package:coleapp/features/parent/presentation/agenda/bloc/AgendaState.dart'
    show AgendaView;

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

class ChangeDate extends CuotasEvent {
  final DateTime date;

  ChangeDate({required this.date});
}

class ChangeView extends CuotasEvent {
  final AgendaView view;

  ChangeView({required this.view});
}

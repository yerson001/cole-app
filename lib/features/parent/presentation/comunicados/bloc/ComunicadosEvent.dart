import 'package:coleapp/features/parent/data/models/student_model.dart';
import 'package:coleapp/features/parent/presentation/agenda/bloc/AgendaState.dart'
    show AgendaView;

abstract class ComunicadosEvent {}

class LoadComunicados extends ComunicadosEvent {
  final int parentId;
  final String tenantId;
  final String startDate;
  final String endDate;
  final int? studentId;
  final List<StudentModel>? students;

  LoadComunicados({
    required this.parentId,
    required this.tenantId,
    required this.startDate,
    required this.endDate,
    this.studentId,
    this.students,
  });
}

class SelectStudent extends ComunicadosEvent {
  final int? studentId;

  SelectStudent({this.studentId});
}

class MarkComunicadoAsRead extends ComunicadosEvent {
  final int itemId;

  MarkComunicadoAsRead({required this.itemId});
}

class ChangeDate extends ComunicadosEvent {
  final DateTime date;

  ChangeDate({required this.date});
}

class ChangeView extends ComunicadosEvent {
  final AgendaView view;

  ChangeView({required this.view});
}
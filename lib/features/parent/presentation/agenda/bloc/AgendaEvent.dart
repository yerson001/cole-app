import 'package:coleapp/features/parent/data/models/student_model.dart';
import 'package:coleapp/features/parent/presentation/agenda/bloc/AgendaState.dart';

abstract class AgendaEvent {}

class LoadAgenda extends AgendaEvent {
  final int? parentId;
  final int? studentId;
  final String tenantId;
  final String startDate;
  final String endDate;
  final List<StudentModel>? students;

  LoadAgenda({
    this.parentId,
    this.studentId,
    required this.tenantId,
    required this.startDate,
    required this.endDate,
    this.students,
  });
}

class SelectStudent extends AgendaEvent {
  final StudentModel? student;

  SelectStudent({this.student});
}

class ChangeDate extends AgendaEvent {
  final DateTime date;

  ChangeDate({required this.date});
}

class ChangeView extends AgendaEvent {
  final AgendaView view;

  ChangeView({required this.view});
}

class MarkItemAsRead extends AgendaEvent {
  final int itemId;

  MarkItemAsRead({required this.itemId});
}

import 'package:coleapp/features/parent/data/models/student_model.dart';

abstract class AgendaEvent {}

class LoadAgenda extends AgendaEvent {
  final int? parentId;
  final int? studentId;
  final String tenantId;
  final String startDate;
  final String endDate;

  LoadAgenda({
    this.parentId,
    this.studentId,
    required this.tenantId,
    required this.startDate,
    required this.endDate,
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

class MarkItemAsRead extends AgendaEvent {
  final String itemId;

  MarkItemAsRead({required this.itemId});
}

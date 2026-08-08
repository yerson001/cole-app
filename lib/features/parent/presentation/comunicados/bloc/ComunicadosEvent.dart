abstract class ComunicadosEvent {}

class LoadComunicados extends ComunicadosEvent {
  final int parentId;
  final String tenantId;
  final String startDate;
  final String endDate;
  final int? studentId;

  LoadComunicados({
    required this.parentId,
    required this.tenantId,
    required this.startDate,
    required this.endDate,
    this.studentId,
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

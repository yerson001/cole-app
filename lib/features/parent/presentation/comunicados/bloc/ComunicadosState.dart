import 'package:equatable/equatable.dart';
import 'package:coleapp/features/parent/data/models/agenda_model.dart';
import 'package:coleapp/features/parent/data/models/student_model.dart';
import 'package:coleapp/features/parent/presentation/agenda/bloc/AgendaState.dart'
    show AgendaView;

class ComunicadosState extends Equatable {
  final List<AgendaItemModel> comunicados;
  final bool isLoading;
  final String? error;
  final int? selectedStudentId;
  final String tenantId;
  final int? parentId;
  final DateTime selectedDate;
  final AgendaView view;
  final List<StudentModel> students;

  const ComunicadosState({
    this.comunicados = const [],
    this.isLoading = false,
    this.error,
    this.selectedStudentId,
    this.tenantId = '',
    this.parentId,
    required this.selectedDate,
    this.view = AgendaView.daily,
    this.students = const [],
  });

  ComunicadosState copyWith({
    List<AgendaItemModel>? comunicados,
    bool? isLoading,
    String? error,
    int? selectedStudentId,
    String? tenantId,
    int? parentId,
    DateTime? selectedDate,
    AgendaView? view,
    List<StudentModel>? students,
    bool clearError = false,
    bool clearSelection = false,
  }) {
    return ComunicadosState(
      comunicados: comunicados ?? this.comunicados,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      selectedStudentId: clearSelection
          ? null
          : (selectedStudentId ?? this.selectedStudentId),
      tenantId: tenantId ?? this.tenantId,
      parentId: parentId ?? this.parentId,
      selectedDate: selectedDate ?? this.selectedDate,
      view: view ?? this.view,
      students: students ?? this.students,
    );
  }

  List<AgendaItemModel> itemsOn(DateTime date) {
    return comunicados.where((item) {
      if (item.publishedAt == null) return false;
      final published = DateTime.tryParse(item.publishedAt!);
      if (published == null) return false;
      return published.year == date.year &&
          published.month == date.month &&
          published.day == date.day;
    }).toList()
      ..sort((a, b) {
        final aDate = DateTime.tryParse(a.publishedAt ?? '') ?? DateTime(0);
        final bDate = DateTime.tryParse(b.publishedAt ?? '') ?? DateTime(0);
        return bDate.compareTo(aDate);
      });
  }

  List<AgendaItemModel> get itemsForSelectedDate => itemsOn(selectedDate);

  @override
  List<Object?> get props => [
    comunicados,
    isLoading,
    error,
    selectedStudentId,
    tenantId,
    parentId,
    selectedDate,
    view,
    students,
  ];
}
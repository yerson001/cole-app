import 'package:equatable/equatable.dart';
import 'package:coleapp/features/parent/data/models/agenda_model.dart';
import 'package:coleapp/features/parent/data/models/student_model.dart';

class AgendaState extends Equatable {
  final DateTime selectedDate;
  final List<AgendaItemModel> items;
  final List<StudentModel> students;
  final StudentModel? selectedStudent;
  final bool isLoading;
  final String? error;
  final String tenantId;
  final int? parentId;

  const AgendaState({
    required this.selectedDate,
    this.items = const [],
    this.students = const [],
    this.selectedStudent,
    this.isLoading = false,
    this.error,
    this.tenantId = '',
    this.parentId,
  });

  AgendaState copyWith({
    DateTime? selectedDate,
    List<AgendaItemModel>? items,
    List<StudentModel>? students,
    StudentModel? selectedStudent,
    bool? isLoading,
    String? error,
    String? tenantId,
    int? parentId,
    bool clearError = false,
  }) {
    return AgendaState(
      selectedDate: selectedDate ?? this.selectedDate,
      items: items ?? this.items,
      students: students ?? this.students,
      selectedStudent: selectedStudent ?? this.selectedStudent,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      tenantId: tenantId ?? this.tenantId,
      parentId: parentId ?? this.parentId,
    );
  }

  List<AgendaItemModel> get itemsForSelectedDate {
    return items.where((item) {
      if (item.publishedAt == null) return false;
      final published = DateTime.tryParse(item.publishedAt!);
      if (published == null) return false;
      return published.year == selectedDate.year &&
          published.month == selectedDate.month &&
          published.day == selectedDate.day;
    }).toList()
      ..sort((a, b) {
        final aDate = DateTime.tryParse(a.publishedAt ?? '') ?? DateTime(0);
        final bDate = DateTime.tryParse(b.publishedAt ?? '') ?? DateTime(0);
        return bDate.compareTo(aDate);
      });
  }

  @override
  List<Object?> get props => [
    selectedDate,
    items,
    students,
    selectedStudent,
    isLoading,
    error,
    tenantId,
    parentId,
  ];
}

import 'package:equatable/equatable.dart';
import 'package:coleapp/features/parent/data/models/agenda_model.dart';
import 'package:coleapp/features/parent/data/models/student_model.dart';

enum AgendaView { daily, weekly, monthly }

class AgendaState extends Equatable {
  final DateTime selectedDate;
  final AgendaView view;
  final List<AgendaItemModel> items;
  final List<StudentModel> students;
  final StudentModel? selectedStudent;
  final bool isLoading;
  final String? error;
  final String tenantId;
  final int? parentId;

  const AgendaState({
    required this.selectedDate,
    this.view = AgendaView.daily,
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
    AgendaView? view,
    List<AgendaItemModel>? items,
    List<StudentModel>? students,
    StudentModel? selectedStudent,
    bool? isLoading,
    String? error,
    String? tenantId,
    int? parentId,
    bool clearError = false,
    bool clearSelection = false,
  }) {
    return AgendaState(
      selectedDate: selectedDate ?? this.selectedDate,
      view: view ?? this.view,
      items: items ?? this.items,
      students: students ?? this.students,
      selectedStudent: clearSelection
          ? null
          : (selectedStudent ?? this.selectedStudent),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      tenantId: tenantId ?? this.tenantId,
      parentId: parentId ?? this.parentId,
    );
  }

  List<AgendaItemModel> itemsOn(DateTime date) {
    return items.where((item) {
      final published = item.localDate;
      if (published == null) return false;
      return published.year == date.year &&
          published.month == date.month &&
          published.day == date.day;
    }).toList()
      ..sort((a, b) {
        final aDate = a.localDate ?? DateTime(0);
        final bDate = b.localDate ?? DateTime(0);
        return bDate.compareTo(aDate);
      });
  }

  List<AgendaItemModel> get itemsForSelectedDate => itemsOn(selectedDate);

  DateTime get startOfWeek {
    final monday = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    return DateTime(monday.year, monday.month, monday.day);
  }

  List<DateTime> get weekDays {
    final start = startOfWeek;
    return List.generate(7, (i) => start.add(Duration(days: i)));
  }

  List<DateTime> get monthDays {
    final first = DateTime(selectedDate.year, selectedDate.month, 1);
    final daysInMonth = DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
    final leading = first.weekday - 1;
    final total = ((leading + daysInMonth) / 7).ceil() * 7;
    final start = first.subtract(Duration(days: leading));
    return List.generate(total, (i) => start.add(Duration(days: i)));
  }

  bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  List<Object?> get props => [
    selectedDate,
    view,
    items,
    students,
    selectedStudent,
    isLoading,
    error,
    tenantId,
    parentId,
  ];
}

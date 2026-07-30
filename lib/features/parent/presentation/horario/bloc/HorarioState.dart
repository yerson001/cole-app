import 'package:equatable/equatable.dart';
import 'package:coleapp/features/parent/data/models/schedule_model.dart';
import 'package:coleapp/features/parent/data/models/student_model.dart';

class HorarioState extends Equatable {
  final StudentModel? selectedStudent;
  final List<ScheduleModel> schedule;
  final bool isLoading;
  final String? error;
  final String tenantId;

  const HorarioState({
    this.selectedStudent,
    this.schedule = const [],
    this.isLoading = false,
    this.error,
    this.tenantId = '',
  });

  HorarioState copyWith({
    StudentModel? selectedStudent,
    List<ScheduleModel>? schedule,
    bool? isLoading,
    String? error,
    String? tenantId,
    bool clearError = false,
  }) {
    return HorarioState(
      selectedStudent: selectedStudent ?? this.selectedStudent,
      schedule: schedule ?? this.schedule,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      tenantId: tenantId ?? this.tenantId,
    );
  }

  Map<int, List<ScheduleModel>> get scheduleByDay {
    final map = <int, List<ScheduleModel>>{};
    for (final item in schedule) {
      map.putIfAbsent(item.day, () => []).add(item);
    }
    for (final key in map.keys) {
      map[key]!.sort((a, b) => a.startTime.compareTo(b.startTime));
    }
    return map;
  }

  @override
  List<Object?> get props => [selectedStudent, schedule, isLoading, error, tenantId];
}

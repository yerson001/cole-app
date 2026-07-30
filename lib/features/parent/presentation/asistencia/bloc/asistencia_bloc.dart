import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/parent/data/models/day_report_model.dart';
import 'package:coleapp/features/parent/domain/usecases/parent_use_cases.dart';
import 'package:coleapp/features/parent/presentation/asistencia/bloc/asistencia_event.dart';
import 'package:coleapp/features/parent/presentation/asistencia/bloc/asistencia_state.dart';

class AsistenciaBloc extends Bloc<AsistenciaEvent, AsistenciaState> {
  final ParentUseCases parentUseCases;

  AsistenciaBloc(this.parentUseCases)
      : super(AsistenciaState(
          selectedDate: DateTime.now(),
          currentMonth: DateTime.now(),
        )) {
    on<InitializeAsistencia>((event, emit) {
      final initialStudent = event.students.isNotEmpty
          ? event.students.firstWhere(
              (s) => s.id == event.initialStudentId,
              orElse: () => event.students.first,
            )
          : null;
      emit(state.copyWith(
        tenant: event.tenant,
        branchId: event.branchId,
        students: event.students,
        selectedStudent: initialStudent,
      ));
      if (initialStudent != null) {
        add(LoadDailyAttendance());
        add(LoadRangeAttendance());
      }
    });

    on<SelectStudent>((event, emit) {
      emit(state.copyWith(selectedStudent: event.student));
      add(LoadDailyAttendance());
      add(LoadRangeAttendance());
    });

    on<ChangeDate>((event, emit) {
      emit(state.copyWith(selectedDate: event.date));
      add(LoadDailyAttendance());
    });

    on<ChangeMonth>((event, emit) {
      emit(state.copyWith(currentMonth: event.month));
      add(LoadRangeAttendance());
    });

    on<LoadDailyAttendance>((event, emit) async {
      if (state.selectedStudent == null || state.tenant.isEmpty) return;
      emit(state.copyWith(isLoadingDaily: true));
      final result = await parentUseCases.getDayReportUseCase.call(
        date: _formatDate(state.selectedDate),
        branchId: state.branchId,
        studentIds: [state.selectedStudent!.id],
        tenantId: state.tenant,
      );
      if (result is SuccessResource<List<DayReportModel>>) {
        emit(state.copyWith(dailyReports: result.data, isLoadingDaily: false));
      } else {
        emit(state.copyWith(dailyReports: const [], isLoadingDaily: false));
      }
    });

    on<LoadRangeAttendance>((event, emit) async {
      if (state.selectedStudent == null || state.tenant.isEmpty) return;
      emit(state.copyWith(isLoadingRange: true));
      final start = DateTime(state.currentMonth.year, state.currentMonth.month, 1);
      final end = DateTime(state.currentMonth.year, state.currentMonth.month + 1, 0);
      final result = await parentUseCases.getAttendanceInRangeUseCase.call(
        startDate: _formatDate(start),
        endDate: _formatDate(end),
        branchId: state.branchId,
        studentIds: [state.selectedStudent!.id],
        tenantId: state.tenant,
      );
      if (result is SuccessResource<List<DayReportModel>>) {
        emit(state.copyWith(rangeReports: result.data, isLoadingRange: false));
      } else {
        emit(state.copyWith(rangeReports: const [], isLoadingRange: false));
      }
    });

    on<ReloadAll>((event, emit) {
      add(LoadDailyAttendance());
      add(LoadRangeAttendance());
    });
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

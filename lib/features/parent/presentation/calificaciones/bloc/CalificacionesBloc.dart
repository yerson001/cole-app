import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/parent/data/models/student_grade_model.dart';
import 'package:coleapp/features/parent/domain/usecases/parent_use_cases.dart';
import 'package:coleapp/features/parent/presentation/calificaciones/bloc/CalificacionesEvent.dart';
import 'package:coleapp/features/parent/presentation/calificaciones/bloc/CalificacionesState.dart';

class CalificacionesBloc extends Bloc<CalificacionesEvent, CalificacionesState> {
  final ParentUseCases parentUseCases;

  CalificacionesBloc(this.parentUseCases) : super(const CalificacionesState()) {
    on<LoadCalificaciones>((event, emit) async {
      emit(state.copyWith(
        isLoading: true,
        tenantId: event.tenantId,
        selectedStudent: event.student,
        clearError: true,
      ));

      final result = await parentUseCases.getStudentGradesByStudentUseCase.call(
        event.student.id,
        tenantId: event.tenantId,
      );

      if (result is SuccessResource<List<StudentGradeModel>>) {
        emit(state.copyWith(
          grades: result.data,
          isLoading: false,
          clearError: true,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: (result as ErrorResource).message,
          grades: const [],
        ));
      }
    });

    on<SelectStudent>((event, emit) {
      emit(state.copyWith(selectedStudent: event.student));
      if (state.tenantId.isNotEmpty) {
        add(LoadCalificaciones(student: event.student, tenantId: state.tenantId));
      }
    });
  }
}

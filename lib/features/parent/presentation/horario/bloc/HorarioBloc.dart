import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/parent/data/models/schedule_model.dart';
import 'package:coleapp/features/parent/domain/usecases/parent_use_cases.dart';
import 'package:coleapp/features/parent/presentation/horario/bloc/HorarioEvent.dart';
import 'package:coleapp/features/parent/presentation/horario/bloc/HorarioState.dart';

class HorarioBloc extends Bloc<HorarioEvent, HorarioState> {
  final ParentUseCases parentUseCases;

  HorarioBloc(this.parentUseCases) : super(const HorarioState()) {
    on<LoadHorario>((event, emit) async {
      emit(state.copyWith(
        isLoading: true,
        tenantId: event.tenantId,
        selectedStudent: event.student,
        clearError: true,
      ));

      final result = await parentUseCases.getScheduleBySectionIdUseCase.call(
        event.student.section.id,
        tenantId: event.tenantId,
      );

      if (result is SuccessResource<List<ScheduleModel>>) {
        emit(state.copyWith(
          schedule: result.data,
          isLoading: false,
          clearError: true,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: (result as ErrorResource).message,
          schedule: const [],
        ));
      }
    });

    on<SelectStudent>((event, emit) {
      emit(state.copyWith(selectedStudent: event.student));
      if (state.tenantId.isNotEmpty) {
        add(LoadHorario(student: event.student, tenantId: state.tenantId));
      }
    });
  }
}

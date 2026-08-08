import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/parent/data/models/fee_model.dart';
import 'package:coleapp/features/parent/domain/usecases/parent_use_cases.dart';
import 'package:coleapp/features/parent/presentation/cuotas/bloc/CuotasEvent.dart';
import 'package:coleapp/features/parent/presentation/cuotas/bloc/CuotasState.dart';

class CuotasBloc extends Bloc<CuotasEvent, CuotasState> {
  final ParentUseCases parentUseCases;

  CuotasBloc(this.parentUseCases) : super(const CuotasState()) {
    on<LoadCuotas>((event, emit) async {
      emit(state.copyWith(
        isLoading: true,
        tenantId: event.tenantId,
        selectedStudent: event.student,
        clearError: true,
      ));

      final result = await parentUseCases.getFeesByStudentUseCase.call(
        event.student.id,
        tenantId: event.tenantId,
      );

      if (result is SuccessResource<List<FeeModel>>) {
        emit(state.copyWith(
          fees: result.data,
          isLoading: false,
          clearError: true,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: (result as ErrorResource).message,
          fees: const [],
        ));
      }
    });

    on<SelectStudent>((event, emit) {
      emit(state.copyWith(selectedStudent: event.student));
      if (state.tenantId.isNotEmpty) {
        add(LoadCuotas(student: event.student, tenantId: state.tenantId));
      }
    });
  }
}

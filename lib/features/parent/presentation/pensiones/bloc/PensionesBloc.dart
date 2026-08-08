import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/parent/data/models/pension_model.dart';
import 'package:coleapp/features/parent/domain/usecases/parent_use_cases.dart';
import 'package:coleapp/features/parent/presentation/pensiones/bloc/PensionesEvent.dart';
import 'package:coleapp/features/parent/presentation/pensiones/bloc/PensionesState.dart';

class PensionesBloc extends Bloc<PensionesEvent, PensionesState> {
  final ParentUseCases parentUseCases;

  PensionesBloc(this.parentUseCases) : super(const PensionesState()) {
    on<LoadPensiones>((event, emit) async {
      emit(state.copyWith(
        isLoading: true,
        tenantId: event.tenantId,
        selectedStudent: event.student,
        clearError: true,
      ));

      final feesResult = await parentUseCases.getStudentFeesByStudentUseCase.call(
        event.student.id,
        tenantId: event.tenantId,
      );
      final paymentsResult = await parentUseCases.getMonthlyPaymentsByStudentUseCase.call(
        event.student.id,
        tenantId: event.tenantId,
      );

      if (feesResult is SuccessResource<List<StudentFeeModel>> &&
          paymentsResult is SuccessResource<List<MonthlyPaymentModel>>) {
        emit(state.copyWith(
          fees: feesResult.data,
          payments: paymentsResult.data,
          isLoading: false,
          clearError: true,
        ));
      } else {
        final feesError = feesResult is ErrorResource ? (feesResult as ErrorResource).message : null;
        final paymentsError = paymentsResult is ErrorResource ? (paymentsResult as ErrorResource).message : null;
        emit(state.copyWith(
          isLoading: false,
          error: feesError ?? paymentsError,
          fees: const [],
          payments: const [],
        ));
      }
    });

    on<SelectStudent>((event, emit) {
      emit(state.copyWith(selectedStudent: event.student));
      if (state.tenantId.isNotEmpty) {
        add(LoadPensiones(student: event.student, tenantId: state.tenantId));
      }
    });
  }
}

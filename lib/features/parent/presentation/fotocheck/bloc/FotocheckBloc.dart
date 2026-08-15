import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/core/services/photocheck_qr_service.dart';
import 'package:coleapp/features/parent/data/models/student_model.dart';
import 'package:coleapp/features/parent/domain/usecases/parent_use_cases.dart';
import 'package:coleapp/features/parent/presentation/fotocheck/bloc/FotocheckEvent.dart';
import 'package:coleapp/features/parent/presentation/fotocheck/bloc/FotocheckState.dart';

class FotocheckBloc extends Bloc<FotocheckEvent, FotocheckState> {
  final ParentUseCases parentUseCases;

  FotocheckBloc(this.parentUseCases) : super(const FotocheckState()) {
    on<LoadFotocheck>((event, emit) async {
      emit(state.copyWith(
        isLoading: true,
        selectedStudent: event.student,
        branchId: event.branchId,
        clearError: true,
      ));

      int tenantId = state.tenantId ?? 0;
      if (tenantId == 0) {
        final result = await parentUseCases.getTenantIdByKeyUseCase.call(event.tenantKey);
        if (result is SuccessResource<int>) {
          tenantId = result.data;
        } else {
          emit(state.copyWith(
            isLoading: false,
            error: (result as ErrorResource).message,
          ));
          return;
        }
      }

      emit(state.copyWith(
        tenantId: tenantId,
        prefix: PhotocheckQrService.buildPrefix(
          tenantId: tenantId,
          branchId: event.branchId,
          studentId: event.student.id,
        ),
        qrData: _buildQrData(event.student, tenantId, event.branchId),
        isLoading: false,
        clearError: true,
      ));
    });

    on<SelectStudent>((event, emit) {
      emit(state.copyWith(selectedStudent: event.student));
      if (state.tenantId != null && state.branchId != null) {
        emit(state.copyWith(
          prefix: PhotocheckQrService.buildPrefix(
            tenantId: state.tenantId!,
            branchId: state.branchId!,
            studentId: event.student.id,
          ),
          qrData: _buildQrData(event.student, state.tenantId!, state.branchId!),
        ));
      }
    });

    on<ChangeTemplate>((event, emit) {
      emit(state.copyWith(template: event.template));
    });
  }

  String _buildQrData(StudentModel student, int tenantId, int branchId) {
    return PhotocheckQrService.encryptData(
      tenantId: tenantId,
      branchId: branchId,
      studentId: student.id,
      studentName: student.fullName,
      level: student.level.name,
      degree: student.grade.name,
      section: student.section.name,
    );
  }
}

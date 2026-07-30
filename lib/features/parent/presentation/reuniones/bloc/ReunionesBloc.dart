import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/parent/data/models/meeting_model.dart';
import 'package:coleapp/features/parent/domain/usecases/parent_use_cases.dart';
import 'package:coleapp/features/parent/presentation/reuniones/bloc/ReunionesEvent.dart';
import 'package:coleapp/features/parent/presentation/reuniones/bloc/ReunionesState.dart';

class ReunionesBloc extends Bloc<ReunionesEvent, ReunionesState> {
  final ParentUseCases parentUseCases;

  ReunionesBloc(this.parentUseCases) : super(const ReunionesState()) {
    on<LoadMeetings>((event, emit) async {
      emit(state.copyWith(
        isLoading: true,
        parentId: event.parentId,
        tenantId: event.tenantId,
        clearError: true,
      ));
      final result = await parentUseCases.getMeetingsByParentUseCase.call(
        event.parentId,
        tenantId: event.tenantId,
      );
      if (result is SuccessResource<List<ParentMeetingModel>>) {
        emit(state.copyWith(
          meetings: result.data,
          isLoading: false,
          clearError: true,
        ));
      } else {
        final message = (result as ErrorResource).message;
        emit(state.copyWith(
          isLoading: false,
          error: message,
          meetings: const [],
        ));
      }
    });

    on<CheckInMeeting>((event, emit) async {
      if (state.parentId == 0 || state.tenantId.isEmpty) return;
      emit(state.copyWith(isLoading: true, clearError: true));
      final result = await parentUseCases.checkInMeetingByParentUseCase.call(
        parentId: state.parentId,
        meetingId: event.meetingId,
        tenantId: state.tenantId,
      );
      if (result is SuccessResource<void>) {
        add(LoadMeetings(parentId: state.parentId, tenantId: state.tenantId));
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: (result as ErrorResource).message,
        ));
      }
    });

    on<CheckOutMeeting>((event, emit) async {
      if (state.parentId == 0 || state.tenantId.isEmpty) return;
      emit(state.copyWith(isLoading: true, clearError: true));
      final result = await parentUseCases.checkOutMeetingByParentUseCase.call(
        parentId: state.parentId,
        meetingId: event.meetingId,
        tenantId: state.tenantId,
      );
      if (result is SuccessResource<void>) {
        add(LoadMeetings(parentId: state.parentId, tenantId: state.tenantId));
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: (result as ErrorResource).message,
        ));
      }
    });
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/parent/data/models/agenda_model.dart';
import 'package:coleapp/features/parent/domain/usecases/parent_use_cases.dart';
import 'package:coleapp/features/parent/presentation/agenda/bloc/AgendaEvent.dart';
import 'package:coleapp/features/parent/presentation/agenda/bloc/AgendaState.dart';

class AgendaBloc extends Bloc<AgendaEvent, AgendaState> {
  final ParentUseCases parentUseCases;

  AgendaBloc(this.parentUseCases) : super(AgendaState(selectedDate: DateTime.now())) {
    on<LoadAgenda>((event, emit) async {
      emit(state.copyWith(
        isLoading: true,
        tenantId: event.tenantId,
        parentId: event.parentId,
        clearError: true,
      ));

      Resource<AgendaModel> result;
      if (event.studentId != null && event.studentId! > 0) {
        result = await parentUseCases.getAgendaByStudentUseCase.call(
          studentId: event.studentId!,
          startDate: event.startDate,
          endDate: event.endDate,
          tenantId: event.tenantId,
        );
      } else if (event.parentId != null && event.parentId! > 0) {
        result = await parentUseCases.getAgendaByParentUseCase.call(
          parentId: event.parentId!,
          startDate: event.startDate,
          endDate: event.endDate,
          tenantId: event.tenantId,
        );
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: 'No se encontró padre o estudiante para cargar la agenda',
        ));
        return;
      }

      if (result is SuccessResource<AgendaModel>) {
        emit(state.copyWith(
          items: result.data.items,
          isLoading: false,
          clearError: true,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: (result as ErrorResource).message,
          items: const [],
        ));
      }
    });

    on<SelectStudent>((event, emit) {
      emit(state.copyWith(selectedStudent: event.student));
      if (state.parentId != null) {
        final range = _dateRangeForDate(state.selectedDate, state.view);
        add(LoadAgenda(
          parentId: state.parentId,
          studentId: event.student?.id,
          tenantId: state.tenantId,
          startDate: range.startDate,
          endDate: range.endDate,
        ));
      }
    });

    on<ChangeDate>((event, emit) async {
      emit(state.copyWith(selectedDate: event.date));
      if (state.parentId != null) {
        final range = _dateRangeForDate(event.date, state.view);
        add(LoadAgenda(
          parentId: state.parentId,
          studentId: state.selectedStudent?.id,
          tenantId: state.tenantId,
          startDate: range.startDate,
          endDate: range.endDate,
        ));
      }
    });

    on<ChangeView>((event, emit) async {
      emit(state.copyWith(view: event.view));
      if (state.parentId != null) {
        final range = _dateRangeForDate(state.selectedDate, event.view);
        add(LoadAgenda(
          parentId: state.parentId,
          studentId: state.selectedStudent?.id,
          tenantId: state.tenantId,
          startDate: range.startDate,
          endDate: range.endDate,
        ));
      }
    });

    on<MarkItemAsRead>((event, emit) async {
      if (state.tenantId.isEmpty) return;
      final result = await parentUseCases.markAgendaItemAsReadUseCase.call(
        itemId: event.itemId,
        tenantId: state.tenantId,
      );
      if (result is SuccessResource<void>) {
        final updatedItems = state.items.map((item) {
          if (item.id == event.itemId) {
            return item.copyWith(readAt: DateTime.now().toIso8601String(), isRead: true);
          }
          return item;
        }).toList();
        emit(state.copyWith(items: updatedItems));
      }
    });
  }

  ({String startDate, String endDate}) _dateRangeForDate(DateTime date, AgendaView view) {
    switch (view) {
      case AgendaView.daily:
        final start = DateTime(date.year, date.month, date.day);
        final end = start.add(const Duration(days: 2));
        return (
          startDate: _formatDate(start),
          endDate: _formatDate(end),
        );
      case AgendaView.weekly:
        final start = date.subtract(Duration(days: date.weekday - 1));
        final startDay = DateTime(start.year, start.month, start.day);
        final end = startDay.add(const Duration(days: 8));
        return (
          startDate: _formatDate(startDay),
          endDate: _formatDate(end),
        );
      case AgendaView.monthly:
        final start = DateTime(date.year, date.month, 1);
        final end = DateTime(date.year, date.month + 1, 1);
        return (
          startDate: _formatDate(start),
          endDate: _formatDate(end),
        );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

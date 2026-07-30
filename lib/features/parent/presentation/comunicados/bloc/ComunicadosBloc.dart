import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/parent/data/models/agenda_model.dart';
import 'package:coleapp/features/parent/domain/usecases/parent_use_cases.dart';
import 'package:coleapp/features/parent/presentation/comunicados/bloc/ComunicadosEvent.dart';
import 'package:coleapp/features/parent/presentation/comunicados/bloc/ComunicadosState.dart';

class ComunicadosBloc extends Bloc<ComunicadosEvent, ComunicadosState> {
  final ParentUseCases parentUseCases;

  ComunicadosBloc(this.parentUseCases) : super(const ComunicadosState()) {
    on<LoadComunicados>((event, emit) async {
      emit(state.copyWith(
        isLoading: true,
        tenantId: event.tenantId,
        parentId: event.parentId,
        selectedStudentId: event.studentId,
        clearError: true,
      ));

      final result = await parentUseCases.getAgendaByParentUseCase.call(
        parentId: event.parentId,
        startDate: event.startDate,
        endDate: event.endDate,
        tenantId: event.tenantId,
      );

      if (result is SuccessResource<AgendaModel>) {
        final announcements = result.data.items
            .where((item) => item.type == 'ANNOUNCEMENT')
            .toList()
          ..sort((a, b) {
            final aDate = DateTime.tryParse(a.publishedAt ?? '') ?? DateTime(0);
            final bDate = DateTime.tryParse(b.publishedAt ?? '') ?? DateTime(0);
            return bDate.compareTo(aDate);
          });
        emit(state.copyWith(
          comunicados: announcements,
          isLoading: false,
          clearError: true,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: (result as ErrorResource).message,
          comunicados: const [],
        ));
      }
    });

    on<SelectStudent>((event, emit) async {
      emit(state.copyWith(selectedStudentId: event.studentId));
      if (state.parentId != null) {
        final range = _dateRangeForMonth(DateTime.now());
        add(LoadComunicados(
          parentId: state.parentId!,
          tenantId: state.tenantId,
          startDate: range.startDate,
          endDate: range.endDate,
          studentId: event.studentId,
        ));
      }
    });

    on<MarkComunicadoAsRead>((event, emit) async {
      if (state.tenantId.isEmpty) return;
      final result = await parentUseCases.markAgendaItemAsReadUseCase.call(
        itemId: event.itemId,
        tenantId: state.tenantId,
      );
      if (result is SuccessResource<void>) {
        final updated = state.comunicados.map((item) {
          if (item.id == event.itemId) {
            return item.copyWith(readAt: DateTime.now().toIso8601String());
          }
          return item;
        }).toList();
        emit(state.copyWith(comunicados: updated));
      }
    });
  }

  ({String startDate, String endDate}) _dateRangeForMonth(DateTime date) {
    final start = DateTime(date.year, date.month, 1);
    final end = DateTime(date.year, date.month + 1, 0);
    return (
      startDate: _formatDate(start),
      endDate: _formatDate(end),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

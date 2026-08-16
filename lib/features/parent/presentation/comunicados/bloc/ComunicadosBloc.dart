import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/parent/data/models/agenda_model.dart';
import 'package:coleapp/features/parent/data/models/student_model.dart';
import 'package:coleapp/features/parent/domain/usecases/parent_use_cases.dart';
import 'package:coleapp/features/parent/presentation/agenda/bloc/AgendaState.dart'
    show AgendaView;
import 'package:coleapp/features/parent/presentation/comunicados/bloc/ComunicadosEvent.dart';
import 'package:coleapp/features/parent/presentation/comunicados/bloc/ComunicadosState.dart';

class ComunicadosBloc extends Bloc<ComunicadosEvent, ComunicadosState> {
  final ParentUseCases parentUseCases;

  ComunicadosBloc(this.parentUseCases)
      : super(ComunicadosState(selectedDate: DateTime.now())) {
    on<LoadComunicados>((event, emit) async {
      emit(state.copyWith(
        isLoading: true,
        tenantId: event.tenantId,
        parentId: event.parentId,
        selectedStudentId: event.studentId,
        students: event.students ?? state.students,
        clearError: true,
      ));

      final sid = event.studentId;
      if (sid != null && sid > 0) {
        final result = await parentUseCases.getAgendaByStudentUseCase.call(
          studentId: sid,
          startDate: event.startDate,
          endDate: event.endDate,
          tenantId: event.tenantId,
        );
        if (result is SuccessResource<AgendaModel>) {
          emit(state.copyWith(
            comunicados: _sortedAnnouncements(result.data.items),
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
        return;
      }

      final students = event.students ?? state.students;
      if (students.isNotEmpty) {
        try {
          final results = await Future.wait(students.map((s) =>
            parentUseCases.getAgendaByStudentUseCase.call(
              studentId: s.id,
              startDate: event.startDate,
              endDate: event.endDate,
              tenantId: event.tenantId,
            )));
          final byId = <int, AgendaItemModel>{};
          for (var i = 0; i < students.length; i++) {
            final result = results[i];
            if (result is SuccessResource<AgendaModel>) {
              final student = students[i];
              for (final item in result.data.items) {
                if (item.type != 'ANNOUNCEMENT') continue;
                byId[item.id] = item.student != null
                    ? item
                    : _withStudent(item, student);
              }
            }
          }
          emit(state.copyWith(
            comunicados: _sortedAnnouncements(byId.values.toList()),
            isLoading: false,
            clearError: true,
          ));
        } catch (_) {
          emit(state.copyWith(
            isLoading: false,
            error: 'No se pudieron cargar los avisos de los hijos',
            comunicados: const [],
          ));
        }
        return;
      }

      final result = await parentUseCases.getAgendaByParentUseCase.call(
        parentId: event.parentId,
        startDate: event.startDate,
        endDate: event.endDate,
        tenantId: event.tenantId,
      );
      if (result is SuccessResource<AgendaModel>) {
        emit(state.copyWith(
          comunicados: _sortedAnnouncements(result.data.items),
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
      emit(state.copyWith(
        selectedStudentId: event.studentId,
        clearSelection: event.studentId == null,
      ));
      if (state.parentId != null) {
        final range = _dateRangeForDate(state.selectedDate, state.view);
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
            return item.copyWith(readAt: DateTime.now().toIso8601String(), isRead: true);
          }
          return item;
        }).toList();
        emit(state.copyWith(comunicados: updated));
      }
    });

    on<ChangeDate>((event, emit) async {
      emit(state.copyWith(selectedDate: event.date));
      if (state.parentId != null) {
        final range = _dateRangeForDate(event.date, state.view);
        add(LoadComunicados(
          parentId: state.parentId!,
          tenantId: state.tenantId,
          startDate: range.startDate,
          endDate: range.endDate,
          studentId: state.selectedStudentId,
        ));
      }
    });

    on<ChangeView>((event, emit) async {
      emit(state.copyWith(view: event.view));
      if (state.parentId != null) {
        final range = _dateRangeForDate(state.selectedDate, event.view);
        add(LoadComunicados(
          parentId: state.parentId!,
          tenantId: state.tenantId,
          startDate: range.startDate,
          endDate: range.endDate,
          studentId: state.selectedStudentId,
        ));
      }
    });
  }

  List<AgendaItemModel> _sortedAnnouncements(List<AgendaItemModel> items) {
    final announcements =
        items.where((item) => item.type == 'ANNOUNCEMENT').toList()
          ..sort((a, b) {
            final aDate = DateTime.tryParse(a.publishedAt ?? '') ?? DateTime(0);
            final bDate = DateTime.tryParse(b.publishedAt ?? '') ?? DateTime(0);
            return bDate.compareTo(aDate);
          });
    return announcements;
  }

  AgendaItemModel _withStudent(AgendaItemModel item, StudentModel student) {
    return item.copyWith(
      student: AgendaStudentModel(
        id: student.id,
        name: student.name,
        lastName: student.lastName,
      ),
    );
  }

  ({String startDate, String endDate}) _dateRangeForDate(
      DateTime date, AgendaView view) {
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

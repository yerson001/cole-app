import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:coleapp/features/parent/data/models/agenda_model.dart';
import 'package:coleapp/features/parent/data/models/day_report_model.dart';
import 'package:coleapp/features/parent/data/models/branch_model.dart';
import 'package:coleapp/features/parent/data/models/meeting_model.dart';
import 'package:coleapp/features/parent/data/models/student_model.dart';
import 'package:coleapp/features/parent/domain/usecases/parent_use_cases.dart';
import 'package:coleapp/features/parent/presentation/home/bloc/ParentHomeEvent.dart';
import 'package:coleapp/features/parent/presentation/home/bloc/ParentHomeState.dart';

class ParentHomeBloc extends Bloc<ParentHomeEvent, ParentHomeState> {
  final AuthUseCases authUseCases;
  final ParentUseCases parentUseCases;

  ParentHomeBloc(this.authUseCases, this.parentUseCases) : super(const ParentHomeState()) {
    on<ChangePage>((event, emit) {
      emit(state.copyWith(
        pageIndex: event.pageIndex,
        previousPageIndex: state.pageIndex,
      ));
      if (event.pageIndex == 0 && state.students.isNotEmpty && state.branch != null) {
        print('[DEBUG] ChangePage to home -> reloading day report');
        add(GetDayReport(
          date: _todayDate(),
          branchId: state.branch!.id,
          studentIds: state.students.map((s) => s.id).toList(),
          tenantId: state.tenant,
        ));
      }
    });

    on<GetParentUser>((event, emit) async {
      final session = await authUseCases.getusersessionUseCase.call();
      if (session != null) {
        final tenant = session.tenant.isNotEmpty ? session.tenant : 'ie-guillermo';
        emit(state.copyWith(user: session.user, tenant: tenant));
        print('[DEBUG] User loaded: ${session.user.username}, tenant: $tenant');
        if (session.user.profile != null) {
          print('[DEBUG] Dispatching GetStudents and GetBranch');
          add(GetBranch(id: 1, tenantId: tenant));
          add(GetStudents(parentId: session.user.profile!.id, tenantId: tenant));
        }
      } else {
        print('[DEBUG] No user session found');
      }
    });

    on<GetBranch>((event, emit) async {
      final result = await parentUseCases.getBranchUseCase
          .call(event.id, tenantId: event.tenantId);
      if (result is SuccessResource<BranchModel>) {
        emit(state.copyWith(branch: result.data));
        print('[DEBUG] Branch loaded: ${result.data.name}');
        if (state.students.isNotEmpty) {
          print('[DEBUG] Students already loaded, triggering GetDayReport');
          add(GetDayReport(
            date: _todayDate(),
            branchId: result.data.id,
            studentIds: state.students.map((s) => s.id).toList(),
            tenantId: state.tenant,
          ));
        }
      }
    });

    on<GetStudents>((event, emit) async {
      print('[DEBUG] GetStudents: parentId=${event.parentId} tenantId=${event.tenantId}');
      final result = await parentUseCases.getStudentsUseCase
          .call(event.parentId, tenantId: event.tenantId);
      if (result is SuccessResource<List<StudentModel>>) {
        print('[DEBUG] Students loaded: ${result.data.length} students');
        emit(state.copyWith(students: result.data));
        print('[DEBUG] Dispatching LoadHomeTabs');
        add(LoadHomeTabs(parentId: event.parentId, tenantId: event.tenantId));
        if (state.branch != null && result.data.isNotEmpty) {
          print('[DEBUG] Branch ready, dispatching GetDayReport');
          add(GetDayReport(
            date: _todayDate(),
            branchId: state.branch!.id,
            studentIds: result.data.map((s) => s.id).toList(),
            tenantId: state.tenant,
          ));
        } else {
          print('[DEBUG] Branch not ready yet (null) or no students');
        }
      } else {
        print('[DEBUG] GetStudents failed: ${(result as ErrorResource).message}');
      }
    });

    on<GetDayReport>((event, emit) async {
      print('[DEBUG] GetDayReport: date=${event.date} branchId=${event.branchId} studentIds=${event.studentIds}');
      emit(state.copyWith(isLoadingDayReport: true));
      final result = await parentUseCases.getDayReportUseCase.call(
        date: event.date,
        branchId: event.branchId,
        studentIds: event.studentIds,
        tenantId: event.tenantId,
      );
      if (result is SuccessResource<List<DayReportModel>>) {
        print('[DEBUG] DayReport success: ${result.data.length} reports from API');
        final reportStudentIds = result.data.map((r) => r.student.id).toSet();
        final reports = [...result.data];
        for (final sid in event.studentIds) {
          if (!reportStudentIds.contains(sid)) {
            final s = state.students.firstWhere((s) => s.id == sid);
            reports.add(DayReportModel(
              student: ReportStudent(
                id: s.id, code: s.code, name: s.name, lastName: s.lastName,
                birthDate: s.birthDate, sex: s.sex, email: s.email, status: s.status,
                level: s.level, grade: s.grade, section: s.section,
              ),
              attendances: [],
            ));
          }
        }
        print('[DEBUG] Total reports after filling: ${reports.length}');
        emit(state.copyWith(dayReports: reports, isLoadingDayReport: false));
      } else {
        print('[DEBUG] DayReport failed: ${(result as ErrorResource).message}');
        final reports = state.students.map((s) => DayReportModel(
          student: ReportStudent(
            id: s.id, code: s.code, name: s.name, lastName: s.lastName,
            birthDate: s.birthDate, sex: s.sex, email: s.email, status: s.status,
            level: s.level, grade: s.grade, section: s.section,
          ),
          attendances: [],
        )).toList();
        print('[DEBUG] Fallback reports: ${reports.length}');
        emit(state.copyWith(dayReports: reports, isLoadingDayReport: false));
      }
    });

    on<Logout>((event, emit) async {
      await parentUseCases.clearBranchUseCase.call();
      await authUseCases.logoutUseCase.call();
    });

    on<LoadHomeTabs>((event, emit) async {
      emit(state.copyWith(isLoadingTabs: true));
      final now = DateTime.now();
      final start = DateTime(now.year, now.month, 1);
      final end = DateTime(now.year, now.month + 1, 0);
      String fmt(DateTime d) =>
          '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

      List<AgendaItemModel> comunicados = const [];
      List<AgendaItemModel> agendaItems = const [];
      List<ParentMeetingModel> meetings = const [];

      final agendaResult = await parentUseCases.getAgendaByParentUseCase.call(
        parentId: event.parentId,
        startDate: fmt(start),
        endDate: fmt(end),
        tenantId: event.tenantId,
      );
      if (agendaResult is SuccessResource<AgendaModel>) {
        final items = agendaResult.data.items;
        comunicados = items
            .where((i) => i.type == 'ANNOUNCEMENT')
            .toList()
          ..sort((a, b) {
            final aDate = DateTime.tryParse(a.publishedAt ?? '') ?? DateTime(0);
            final bDate = DateTime.tryParse(b.publishedAt ?? '') ?? DateTime(0);
            return bDate.compareTo(aDate);
          });
        agendaItems = items.where((i) => i.type != 'ANNOUNCEMENT').toList();
      }

      final meetingsResult = await parentUseCases.getMeetingsByParentUseCase
          .call(event.parentId, tenantId: event.tenantId);
      if (meetingsResult is SuccessResource<List<ParentMeetingModel>>) {
        meetings = meetingsResult.data;
      }

      emit(state.copyWith(
        comunicados: comunicados,
        agendaItems: agendaItems,
        meetings: meetings,
        isLoadingTabs: false,
      ));
    });
  }

  String _todayDate() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}

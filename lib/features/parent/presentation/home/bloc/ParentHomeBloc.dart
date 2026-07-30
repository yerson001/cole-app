import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:coleapp/features/parent/data/models/day_report_model.dart';
import 'package:coleapp/features/parent/data/models/branch_model.dart';
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
    });

    on<GetParentUser>((event, emit) async {
      final session = await authUseCases.getusersessionUseCase.call();
      if (session != null) {
        emit(state.copyWith(user: session.user));
        print('[DEBUG] User loaded: ${session.user.username}, profile id: ${session.user.profile?.id}');
        if (session.user.profile != null) {
          print('[DEBUG] Dispatching GetStudents');
          add(GetStudents(parentId: session.user.profile!.id, tenantId: 'ie-guillermo'));
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
            tenantId: 'ie-guillermo',
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
        if (state.branch != null && result.data.isNotEmpty) {
          print('[DEBUG] Branch ready, dispatching GetDayReport');
          add(GetDayReport(
            date: _todayDate(),
            branchId: state.branch!.id,
            studentIds: result.data.map((s) => s.id).toList(),
            tenantId: 'ie-guillermo',
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
        emit(state.copyWith(dayReports: reports));
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
        emit(state.copyWith(dayReports: reports));
      }
    });

    on<Logout>((event, emit) async {
      await parentUseCases.clearBranchUseCase.call();
      await authUseCases.logoutUseCase.call();
    });
  }

  String _todayDate() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}

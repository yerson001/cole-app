// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:coleapp/di/app_module.dart' as _i425;
import 'package:coleapp/features/auth/data/datasource/local/auth_local_storage.dart'
    as _i800;
import 'package:coleapp/features/auth/data/datasource/remote/auth_service.dart'
    as _i1057;
import 'package:coleapp/features/auth/domain/repositories/auth_repository.dart'
    as _i509;
import 'package:coleapp/features/auth/domain/usecases/auth_use_cases.dart'
    as _i543;
import 'package:coleapp/features/auth/domain/usecases/getUserSession_use_case.dart'
    as _i634;
import 'package:coleapp/features/auth/domain/usecases/login_use_case.dart'
    as _i905;
import 'package:coleapp/features/auth/domain/usecases/logout_use_case.dart'
    as _i690;
import 'package:coleapp/features/auth/domain/usecases/removeUser_use_case.dart'
    as _i507;
import 'package:coleapp/features/auth/domain/usecases/saveUser_use_case.dart'
    as _i1056;
import 'package:coleapp/features/parent/data/datasource/local/parent_local_storage.dart'
    as _i705;
import 'package:coleapp/features/parent/data/datasource/remote/parent_service.dart'
    as _i94;
import 'package:coleapp/features/parent/domain/repositories/parent_repository.dart'
    as _i245;
import 'package:coleapp/features/parent/domain/usecases/check_in_meeting_by_parent_use_case.dart'
    as _i290;
import 'package:coleapp/features/parent/domain/usecases/check_out_meeting_by_parent_use_case.dart'
    as _i236;
import 'package:coleapp/features/parent/domain/usecases/clear_branch_use_case.dart'
    as _i309;
import 'package:coleapp/features/parent/domain/usecases/get_agenda_by_parent_use_case.dart'
    as _i311;
import 'package:coleapp/features/parent/domain/usecases/get_agenda_by_student_use_case.dart'
    as _i107;
import 'package:coleapp/features/parent/domain/usecases/get_announcement_detail_use_case.dart'
    as _i1026;
import 'package:coleapp/features/parent/domain/usecases/get_attendance_in_range_use_case.dart'
    as _i555;
import 'package:coleapp/features/parent/domain/usecases/get_branch_use_case.dart'
    as _i484;
import 'package:coleapp/features/parent/domain/usecases/get_day_report_use_case.dart'
    as _i720;
import 'package:coleapp/features/parent/domain/usecases/get_fees_by_student_use_case.dart'
    as _i1043;
import 'package:coleapp/features/parent/domain/usecases/get_homework_detail_use_case.dart'
    as _i348;
import 'package:coleapp/features/parent/domain/usecases/get_meetings_by_parent_use_case.dart'
    as _i986;
import 'package:coleapp/features/parent/domain/usecases/get_monthly_payments_by_student_use_case.dart'
    as _i746;
import 'package:coleapp/features/parent/domain/usecases/get_observation_detail_use_case.dart'
    as _i766;
import 'package:coleapp/features/parent/domain/usecases/get_schedule_by_section_id_use_case.dart'
    as _i987;
import 'package:coleapp/features/parent/domain/usecases/get_student_fees_by_student_use_case.dart'
    as _i249;
import 'package:coleapp/features/parent/domain/usecases/get_student_grades_by_student_use_case.dart'
    as _i890;
import 'package:coleapp/features/parent/domain/usecases/get_students_use_case.dart'
    as _i31;
import 'package:coleapp/features/parent/domain/usecases/get_tenant_id_by_key_use_case.dart'
    as _i450;
import 'package:coleapp/features/parent/domain/usecases/mark_agenda_item_as_read_use_case.dart'
    as _i962;
import 'package:coleapp/features/parent/domain/usecases/parent_use_cases.dart'
    as _i607;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.factory<_i800.AuthLocalStorage>(() => appModule.authLocalStorage);
    gh.factory<_i1057.AuthService>(() => appModule.authService);
    gh.factory<_i509.AuthRepository>(() => appModule.authRepository);
    gh.factory<_i905.LoginUseCase>(() => appModule.loginUseCase);
    gh.factory<_i1056.SaveuserUseCase>(() => appModule.saveuserUseCase);
    gh.factory<_i634.GetusersessionUseCase>(
      () => appModule.getusersessionUseCase,
    );
    gh.factory<_i507.RemoveuserUseCase>(() => appModule.removeuserUseCase);
    gh.factory<_i690.LogoutUseCase>(() => appModule.logoutUseCase);
    gh.factory<_i543.AuthUseCases>(() => appModule.authUseCases);
    gh.factory<_i705.ParentLocalStorage>(() => appModule.parentLocalStorage);
    gh.factory<_i94.ParentService>(() => appModule.parentService);
    gh.factory<_i245.ParentRepository>(() => appModule.parentRepository);
    gh.factory<_i484.GetBranchUseCase>(() => appModule.getBranchUseCase);
    gh.factory<_i31.GetStudentsUseCase>(() => appModule.getStudentsUseCase);
    gh.factory<_i309.ClearBranchUseCase>(() => appModule.clearBranchUseCase);
    gh.factory<_i720.GetDayReportUseCase>(() => appModule.getDayReportUseCase);
    gh.factory<_i555.GetAttendanceInRangeUseCase>(
      () => appModule.getAttendanceInRangeUseCase,
    );
    gh.factory<_i986.GetMeetingsByParentUseCase>(
      () => appModule.getMeetingsByParentUseCase,
    );
    gh.factory<_i290.CheckInMeetingByParentUseCase>(
      () => appModule.checkInMeetingByParentUseCase,
    );
    gh.factory<_i236.CheckOutMeetingByParentUseCase>(
      () => appModule.checkOutMeetingByParentUseCase,
    );
    gh.factory<_i311.GetAgendaByParentUseCase>(
      () => appModule.getAgendaByParentUseCase,
    );
    gh.factory<_i107.GetAgendaByStudentUseCase>(
      () => appModule.getAgendaByStudentUseCase,
    );
    gh.factory<_i962.MarkAgendaItemAsReadUseCase>(
      () => appModule.markAgendaItemAsReadUseCase,
    );
    gh.factory<_i348.GetHomeworkDetailUseCase>(
      () => appModule.getHomeworkDetailUseCase,
    );
    gh.factory<_i1026.GetAnnouncementDetailUseCase>(
      () => appModule.getAnnouncementDetailUseCase,
    );
    gh.factory<_i766.GetObservationDetailUseCase>(
      () => appModule.getObservationDetailUseCase,
    );
    gh.factory<_i987.GetScheduleBySectionIdUseCase>(
      () => appModule.getScheduleBySectionIdUseCase,
    );
    gh.factory<_i890.GetStudentGradesByStudentUseCase>(
      () => appModule.getStudentGradesByStudentUseCase,
    );
    gh.factory<_i249.GetStudentFeesByStudentUseCase>(
      () => appModule.getStudentFeesByStudentUseCase,
    );
    gh.factory<_i746.GetMonthlyPaymentsByStudentUseCase>(
      () => appModule.getMonthlyPaymentsByStudentUseCase,
    );
    gh.factory<_i1043.GetFeesByStudentUseCase>(
      () => appModule.getFeesByStudentUseCase,
    );
    gh.factory<_i450.GetTenantIdByKeyUseCase>(
      () => appModule.getTenantIdByKeyUseCase,
    );
    gh.factory<_i607.ParentUseCases>(() => appModule.parentUseCases);
    return this;
  }
}

class _$AppModule extends _i425.AppModule {}

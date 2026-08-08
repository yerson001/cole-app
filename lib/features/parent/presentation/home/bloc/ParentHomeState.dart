import 'package:coleapp/features/auth/data/models/user.dart';
import 'package:coleapp/features/parent/data/models/agenda_model.dart';
import 'package:coleapp/features/parent/data/models/branch_model.dart';
import 'package:coleapp/features/parent/data/models/day_report_model.dart';
import 'package:coleapp/features/parent/data/models/meeting_model.dart';
import 'package:coleapp/features/parent/data/models/student_model.dart';
import 'package:equatable/equatable.dart';

class ParentHomeState extends Equatable {
  final int pageIndex;
  final int previousPageIndex;
  final User? user;
  final BranchModel? branch;
  final List<StudentModel> students;
  final List<DayReportModel> dayReports;
  final String tenant;
  final bool isLoadingDayReport;
  final List<AgendaItemModel> comunicados;
  final List<ParentMeetingModel> meetings;
  final List<AgendaItemModel> agendaItems;
  final bool isLoadingTabs;

  const ParentHomeState({
    this.pageIndex = 0,
    this.previousPageIndex = 0,
    this.user,
    this.branch,
    this.students = const [],
    this.dayReports = const [],
    this.tenant = '',
    this.isLoadingDayReport = false,
    this.comunicados = const [],
    this.meetings = const [],
    this.agendaItems = const [],
    this.isLoadingTabs = false,
  });

  ParentHomeState copyWith({
    int? pageIndex,
    int? previousPageIndex,
    User? user,
    BranchModel? branch,
    List<StudentModel>? students,
    List<DayReportModel>? dayReports,
    String? tenant,
    bool? isLoadingDayReport,
    List<AgendaItemModel>? comunicados,
    List<ParentMeetingModel>? meetings,
    List<AgendaItemModel>? agendaItems,
    bool? isLoadingTabs,
  }) {
    return ParentHomeState(
      pageIndex: pageIndex ?? this.pageIndex,
      previousPageIndex: previousPageIndex ?? this.previousPageIndex,
      user: user ?? this.user,
      branch: branch ?? this.branch,
      students: students ?? this.students,
      dayReports: dayReports ?? this.dayReports,
      tenant: tenant ?? this.tenant,
      isLoadingDayReport: isLoadingDayReport ?? this.isLoadingDayReport,
      comunicados: comunicados ?? this.comunicados,
      meetings: meetings ?? this.meetings,
      agendaItems: agendaItems ?? this.agendaItems,
      isLoadingTabs: isLoadingTabs ?? this.isLoadingTabs,
    );
  }

  @override
  List<Object?> get props => [
    pageIndex,
    previousPageIndex,
    user,
    branch,
    students,
    dayReports,
    tenant,
    isLoadingDayReport,
    comunicados,
    meetings,
    agendaItems,
    isLoadingTabs,
  ];
}

import 'package:coleapp/features/parent/domain/usecases/clear_branch_use_case.dart';
import 'package:coleapp/features/parent/domain/usecases/get_branch_use_case.dart';
import 'package:coleapp/features/parent/domain/usecases/check_in_meeting_by_parent_use_case.dart';
import 'package:coleapp/features/parent/domain/usecases/check_out_meeting_by_parent_use_case.dart';
import 'package:coleapp/features/parent/domain/usecases/get_agenda_by_parent_use_case.dart';
import 'package:coleapp/features/parent/domain/usecases/get_agenda_by_student_use_case.dart';
import 'package:coleapp/features/parent/domain/usecases/get_attendance_in_range_use_case.dart';
import 'package:coleapp/features/parent/domain/usecases/get_day_report_use_case.dart';
import 'package:coleapp/features/parent/domain/usecases/get_meetings_by_parent_use_case.dart';
import 'package:coleapp/features/parent/domain/usecases/get_schedule_by_section_id_use_case.dart';
import 'package:coleapp/features/parent/domain/usecases/get_student_grades_by_student_use_case.dart';
import 'package:coleapp/features/parent/domain/usecases/get_students_use_case.dart';
import 'package:coleapp/features/parent/domain/usecases/mark_agenda_item_as_read_use_case.dart';

class ParentUseCases {
  final GetBranchUseCase getBranchUseCase;
  final ClearBranchUseCase clearBranchUseCase;
  final GetStudentsUseCase getStudentsUseCase;
  final GetDayReportUseCase getDayReportUseCase;
  final GetAttendanceInRangeUseCase getAttendanceInRangeUseCase;
  final GetMeetingsByParentUseCase getMeetingsByParentUseCase;
  final CheckInMeetingByParentUseCase checkInMeetingByParentUseCase;
  final CheckOutMeetingByParentUseCase checkOutMeetingByParentUseCase;
  final GetAgendaByParentUseCase getAgendaByParentUseCase;
  final GetAgendaByStudentUseCase getAgendaByStudentUseCase;
  final MarkAgendaItemAsReadUseCase markAgendaItemAsReadUseCase;
  final GetScheduleBySectionIdUseCase getScheduleBySectionIdUseCase;
  final GetStudentGradesByStudentUseCase getStudentGradesByStudentUseCase;

  ParentUseCases({
    required this.getBranchUseCase,
    required this.clearBranchUseCase,
    required this.getStudentsUseCase,
    required this.getDayReportUseCase,
    required this.getAttendanceInRangeUseCase,
    required this.getMeetingsByParentUseCase,
    required this.checkInMeetingByParentUseCase,
    required this.checkOutMeetingByParentUseCase,
    required this.getAgendaByParentUseCase,
    required this.getAgendaByStudentUseCase,
    required this.markAgendaItemAsReadUseCase,
    required this.getScheduleBySectionIdUseCase,
    required this.getStudentGradesByStudentUseCase,
  });
}

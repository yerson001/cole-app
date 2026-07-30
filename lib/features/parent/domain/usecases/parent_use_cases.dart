import 'package:coleapp/features/parent/domain/usecases/clear_branch_use_case.dart';
import 'package:coleapp/features/parent/domain/usecases/get_branch_use_case.dart';
import 'package:coleapp/features/parent/domain/usecases/get_attendance_in_range_use_case.dart';
import 'package:coleapp/features/parent/domain/usecases/get_day_report_use_case.dart';
import 'package:coleapp/features/parent/domain/usecases/get_students_use_case.dart';

class ParentUseCases {
  final GetBranchUseCase getBranchUseCase;
  final ClearBranchUseCase clearBranchUseCase;
  final GetStudentsUseCase getStudentsUseCase;
  final GetDayReportUseCase getDayReportUseCase;
  final GetAttendanceInRangeUseCase getAttendanceInRangeUseCase;

  ParentUseCases({
    required this.getBranchUseCase,
    required this.clearBranchUseCase,
    required this.getStudentsUseCase,
    required this.getDayReportUseCase,
    required this.getAttendanceInRangeUseCase,
  });
}

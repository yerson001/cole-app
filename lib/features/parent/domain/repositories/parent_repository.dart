import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/parent/data/models/agenda_model.dart';
import 'package:coleapp/features/parent/data/models/branch_model.dart';
import 'package:coleapp/features/parent/data/models/day_report_model.dart';
import 'package:coleapp/features/parent/data/models/meeting_model.dart';
import 'package:coleapp/features/parent/data/models/schedule_model.dart';
import 'package:coleapp/features/parent/data/models/student_grade_model.dart';
import 'package:coleapp/features/parent/data/models/student_model.dart';

abstract class ParentRepository {
  Future<Resource<BranchModel>> getBranch(int id, {required String tenantId});
  Future<Resource<List<StudentModel>>> getStudentsByParent(int parentId, {required String tenantId});
  Future<Resource<List<DayReportModel>>> getDayReport({
    required String date,
    required int branchId,
    required List<int> studentIds,
    required String tenantId,
  });
  Future<Resource<List<DayReportModel>>> getAttendanceInRange({
    required String startDate,
    required String endDate,
    required int branchId,
    required List<int> studentIds,
    required String tenantId,
  });
  Future<Resource<List<ParentMeetingModel>>> getMeetingsByParent(int parentId, {required String tenantId});
  Future<Resource<void>> checkInMeetingByParent({required int parentId, required int meetingId, required String tenantId});
  Future<Resource<void>> checkOutMeetingByParent({required int parentId, required int meetingId, required String tenantId});
  Future<Resource<AgendaModel>> getAgendaByParent({
    required int parentId,
    required String startDate,
    required String endDate,
    required String tenantId,
  });
  Future<Resource<AgendaModel>> getAgendaByStudent({
    required int studentId,
    required String startDate,
    required String endDate,
    required String tenantId,
  });
  Future<Resource<void>> markAgendaItemAsRead({required String itemId, required String tenantId});
  Future<Resource<List<ScheduleModel>>> getScheduleBySectionId(int sectionId, {required String tenantId});
  Future<Resource<List<StudentGradeModel>>> getStudentGradesByStudent(int studentId, {required String tenantId});
  Future<void> clearBranch();
}

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/parent/data/datasource/local/parent_local_storage.dart';
import 'package:coleapp/features/parent/data/datasource/remote/parent_service.dart';
import 'package:coleapp/features/parent/data/models/agenda_model.dart';
import 'package:coleapp/features/parent/data/models/branch_model.dart';
import 'package:coleapp/features/parent/data/models/day_report_model.dart';
import 'package:coleapp/features/parent/data/models/fee_model.dart';
import 'package:coleapp/features/parent/data/models/meeting_model.dart';
import 'package:coleapp/features/parent/data/models/pension_model.dart';
import 'package:coleapp/features/parent/data/models/schedule_model.dart';
import 'package:coleapp/features/parent/data/models/student_grade_model.dart';
import 'package:coleapp/features/parent/data/models/student_model.dart';
import 'package:coleapp/features/parent/domain/repositories/parent_repository.dart';

class ParentRepositoryImpl implements ParentRepository {
  final ParentService _service;
  final ParentLocalStorage _storage;

  ParentRepositoryImpl({
    required ParentService service,
    required ParentLocalStorage storage,
  })  : _service = service,
        _storage = storage;

  @override
  Future<Resource<BranchModel>> getBranch(int id,
      {required String tenantId}) async {
    try {
      final local = await _storage.getBranch();
      if (local != null) {
        final remote = await _service.getBranch(id, tenantId: tenantId);
        await _storage.saveBranch(remote);
        return SuccessResource(remote);
      }
      final remote = await _service.getBranch(id, tenantId: tenantId);
      await _storage.saveBranch(remote);
      return SuccessResource(remote);
    } catch (e) {
      final local = await _storage.getBranch();
      if (local != null) {
        return SuccessResource(local);
      }
      return ErrorResource(e.toString());
    }
  }

  @override
  Future<Resource<List<StudentModel>>> getStudentsByParent(int parentId,
      {required String tenantId}) async {
    try {
      final students = await _service.getStudentsByParent(parentId, tenantId: tenantId);
      return SuccessResource(students);
    } catch (e) {
      return ErrorResource(e.toString());
    }
  }

  @override
  Future<Resource<List<DayReportModel>>> getDayReport({
    required String date,
    required int branchId,
    required List<int> studentIds,
    required String tenantId,
  }) async {
    try {
      final reports = await _service.getDayReport(
        date: date,
        branchId: branchId,
        studentIds: studentIds,
        tenantId: tenantId,
      );
      return SuccessResource(reports);
    } catch (e) {
      return ErrorResource(e.toString());
    }
  }

  @override
  Future<Resource<List<DayReportModel>>> getAttendanceInRange({
    required String startDate,
    required String endDate,
    required int branchId,
    required List<int> studentIds,
    required String tenantId,
  }) async {
    try {
      final reports = await _service.getAttendanceInRange(
        startDate: startDate,
        endDate: endDate,
        branchId: branchId,
        studentIds: studentIds,
        tenantId: tenantId,
      );
      return SuccessResource(reports);
    } catch (e) {
      return ErrorResource(e.toString());
    }
  }

  @override
  Future<Resource<List<ParentMeetingModel>>> getMeetingsByParent(int parentId,
      {required String tenantId}) async {
    try {
      final meetings = await _service.getMeetingsByParent(parentId, tenantId: tenantId);
      return SuccessResource(meetings);
    } catch (e) {
      return ErrorResource(e.toString());
    }
  }

  @override
  Future<Resource<void>> checkInMeetingByParent({
    required int parentId,
    required int meetingId,
    required String tenantId,
  }) async {
    try {
      await _service.checkInMeetingByParent(
        parentId: parentId,
        meetingId: meetingId,
        tenantId: tenantId,
      );
      return SuccessResource(null);
    } catch (e) {
      return ErrorResource(e.toString());
    }
  }

  @override
  Future<Resource<void>> checkOutMeetingByParent({
    required int parentId,
    required int meetingId,
    required String tenantId,
  }) async {
    try {
      await _service.checkOutMeetingByParent(
        parentId: parentId,
        meetingId: meetingId,
        tenantId: tenantId,
      );
      return SuccessResource(null);
    } catch (e) {
      return ErrorResource(e.toString());
    }
  }

  @override
  Future<Resource<AgendaModel>> getAgendaByParent({
    required int parentId,
    required String startDate,
    required String endDate,
    required String tenantId,
  }) async {
    try {
      final agenda = await _service.getAgendaByParent(
        parentId: parentId,
        startDate: startDate,
        endDate: endDate,
        tenantId: tenantId,
      );
      return SuccessResource(agenda);
    } catch (e) {
      return ErrorResource(e.toString());
    }
  }

  @override
  Future<Resource<AgendaModel>> getAgendaByStudent({
    required int studentId,
    required String startDate,
    required String endDate,
    required String tenantId,
  }) async {
    try {
      final agenda = await _service.getAgendaByStudent(
        studentId: studentId,
        startDate: startDate,
        endDate: endDate,
        tenantId: tenantId,
      );
      return SuccessResource(agenda);
    } catch (e) {
      return ErrorResource(e.toString());
    }
  }

  @override
  Future<Resource<void>> markAgendaItemAsRead({
    required int itemId,
    required String tenantId,
  }) async {
    try {
      await _service.markAgendaItemAsRead(itemId: itemId, tenantId: tenantId);
      return SuccessResource(null);
    } catch (e) {
      return ErrorResource(e.toString());
    }
  }

  @override
  Future<Resource<List<ScheduleModel>>> getScheduleBySectionId(int sectionId,
      {required String tenantId}) async {
    try {
      final schedules = await _service.getScheduleBySectionId(sectionId, tenantId: tenantId);
      return SuccessResource(schedules);
    } catch (e) {
      return ErrorResource(e.toString());
    }
  }

  @override
  Future<Resource<List<StudentGradeModel>>> getStudentGradesByStudent(int studentId,
      {required String tenantId}) async {
    try {
      final grades = await _service.getStudentGradesByStudent(studentId, tenantId: tenantId);
      return SuccessResource(grades);
    } catch (e) {
      return ErrorResource(e.toString());
    }
  }

  @override
  Future<Resource<List<StudentFeeModel>>> getStudentFeesByStudent(int studentId,
      {required String tenantId}) async {
    try {
      final fees = await _service.getStudentFeesByStudent(studentId, tenantId: tenantId);
      return SuccessResource(fees);
    } catch (e) {
      return ErrorResource(e.toString());
    }
  }

  @override
  Future<Resource<List<MonthlyPaymentModel>>> getMonthlyPaymentsByStudent(int studentId,
      {required String tenantId}) async {
    try {
      final payments = await _service.getMonthlyPaymentsByStudent(studentId, tenantId: tenantId);
      return SuccessResource(payments);
    } catch (e) {
      return ErrorResource(e.toString());
    }
  }

  @override
  Future<Resource<List<FeeModel>>> getFeesByStudent(int studentId,
      {required String tenantId}) async {
    try {
      final fees = await _service.getFeesByStudent(studentId, tenantId: tenantId);
      return SuccessResource(fees);
    } catch (e) {
      return ErrorResource(e.toString());
    }
  }

  @override
  Future<Resource<int>> getTenantIdByKey(String tenantKey) async {
    try {
      final id = await _service.getTenantIdByKey(tenantKey);
      if (id == null) {
        return ErrorResource('Tenant no encontrado');
      }
      return SuccessResource(id);
    } catch (e) {
      return ErrorResource(e.toString());
    }
  }

  @override
  Future<void> clearBranch() async {
    final branch = await _storage.getBranch();
    if (branch?.urlLogo != null) {
      await DefaultCacheManager().removeFile(branch!.urlLogo!);
    }
    await _storage.removeBranch();
  }
}

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/parent/data/datasource/local/parent_local_storage.dart';
import 'package:coleapp/features/parent/data/datasource/remote/parent_service.dart';
import 'package:coleapp/features/parent/data/models/branch_model.dart';
import 'package:coleapp/features/parent/data/models/day_report_model.dart';
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
  Future<void> clearBranch() async {
    final branch = await _storage.getBranch();
    if (branch?.urlLogo != null) {
      await DefaultCacheManager().removeFile(branch!.urlLogo!);
    }
    await _storage.removeBranch();
  }
}

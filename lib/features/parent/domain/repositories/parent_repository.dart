import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/parent/data/models/branch_model.dart';
import 'package:coleapp/features/parent/data/models/day_report_model.dart';
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
  Future<void> clearBranch();
}

import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/parent/data/models/branch_model.dart';

abstract class ParentRepository {
  Future<Resource<BranchModel>> getBranch(int id, {required String tenantId});
  Future<void> clearBranch();
}

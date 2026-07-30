import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/parent/data/models/branch_model.dart';
import 'package:coleapp/features/parent/domain/repositories/parent_repository.dart';

class GetBranchUseCase {
  final ParentRepository _repository;

  GetBranchUseCase({required ParentRepository repository})
      : _repository = repository;

  Future<Resource<BranchModel>> call(int id, {required String tenantId}) {
    return _repository.getBranch(id, tenantId: tenantId);
  }
}

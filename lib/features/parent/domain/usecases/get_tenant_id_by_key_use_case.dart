import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/parent/domain/repositories/parent_repository.dart';

class GetTenantIdByKeyUseCase {
  final ParentRepository _repository;

  GetTenantIdByKeyUseCase({required ParentRepository repository})
      : _repository = repository;

  Future<Resource<int>> call(String tenantKey) {
    return _repository.getTenantIdByKey(tenantKey);
  }
}

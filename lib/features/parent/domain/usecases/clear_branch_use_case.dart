import 'package:coleapp/features/parent/domain/repositories/parent_repository.dart';

class ClearBranchUseCase {
  final ParentRepository _repository;

  ClearBranchUseCase({required ParentRepository repository})
      : _repository = repository;

  Future<void> call() {
    return _repository.clearBranch();
  }
}

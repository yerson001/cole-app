import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/parent/data/models/fee_model.dart';
import 'package:coleapp/features/parent/domain/repositories/parent_repository.dart';

class GetFeesByStudentUseCase {
  final ParentRepository _repository;

  GetFeesByStudentUseCase({required ParentRepository repository})
      : _repository = repository;

  Future<Resource<List<FeeModel>>> call(int studentId,
      {required String tenantId}) {
    return _repository.getFeesByStudent(studentId, tenantId: tenantId);
  }
}

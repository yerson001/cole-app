import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/parent/data/models/pension_model.dart';
import 'package:coleapp/features/parent/domain/repositories/parent_repository.dart';

class GetStudentFeesByStudentUseCase {
  final ParentRepository _repository;

  GetStudentFeesByStudentUseCase({required ParentRepository repository})
      : _repository = repository;

  Future<Resource<List<StudentFeeModel>>> call(int studentId,
      {required String tenantId}) {
    return _repository.getStudentFeesByStudent(studentId, tenantId: tenantId);
  }
}

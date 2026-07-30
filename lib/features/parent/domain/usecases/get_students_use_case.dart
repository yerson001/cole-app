import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/parent/data/models/student_model.dart';
import 'package:coleapp/features/parent/domain/repositories/parent_repository.dart';

class GetStudentsUseCase {
  final ParentRepository _repository;

  GetStudentsUseCase({required ParentRepository repository})
      : _repository = repository;

  Future<Resource<List<StudentModel>>> call(int parentId,
      {required String tenantId}) {
    return _repository.getStudentsByParent(parentId, tenantId: tenantId);
  }
}

import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/parent/data/models/student_grade_model.dart';
import 'package:coleapp/features/parent/domain/repositories/parent_repository.dart';

class GetStudentGradesByStudentUseCase {
  final ParentRepository _repository;

  GetStudentGradesByStudentUseCase({required ParentRepository repository})
      : _repository = repository;

  Future<Resource<List<StudentGradeModel>>> call(int studentId,
      {required String tenantId}) {
    return _repository.getStudentGradesByStudent(studentId, tenantId: tenantId);
  }
}

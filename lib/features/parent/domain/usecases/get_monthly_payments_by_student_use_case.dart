import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/parent/data/models/pension_model.dart';
import 'package:coleapp/features/parent/domain/repositories/parent_repository.dart';

class GetMonthlyPaymentsByStudentUseCase {
  final ParentRepository _repository;

  GetMonthlyPaymentsByStudentUseCase({required ParentRepository repository})
      : _repository = repository;

  Future<Resource<List<MonthlyPaymentModel>>> call(int studentId,
      {required String tenantId}) {
    return _repository.getMonthlyPaymentsByStudent(studentId, tenantId: tenantId);
  }
}

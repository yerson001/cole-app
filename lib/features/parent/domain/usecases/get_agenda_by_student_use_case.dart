import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/parent/data/models/agenda_model.dart';
import 'package:coleapp/features/parent/domain/repositories/parent_repository.dart';

class GetAgendaByStudentUseCase {
  final ParentRepository _repository;

  GetAgendaByStudentUseCase({required ParentRepository repository})
      : _repository = repository;

  Future<Resource<AgendaModel>> call({
    required int studentId,
    required String startDate,
    required String endDate,
    required String tenantId,
  }) {
    return _repository.getAgendaByStudent(
      studentId: studentId,
      startDate: startDate,
      endDate: endDate,
      tenantId: tenantId,
    );
  }
}

import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/parent/data/models/agenda_model.dart';
import 'package:coleapp/features/parent/domain/repositories/parent_repository.dart';

class GetAgendaByParentUseCase {
  final ParentRepository _repository;

  GetAgendaByParentUseCase({required ParentRepository repository})
      : _repository = repository;

  Future<Resource<AgendaModel>> call({
    required int parentId,
    required String startDate,
    required String endDate,
    required String tenantId,
  }) {
    return _repository.getAgendaByParent(
      parentId: parentId,
      startDate: startDate,
      endDate: endDate,
      tenantId: tenantId,
    );
  }
}

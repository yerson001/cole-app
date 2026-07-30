import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/parent/domain/repositories/parent_repository.dart';

class MarkAgendaItemAsReadUseCase {
  final ParentRepository _repository;

  MarkAgendaItemAsReadUseCase({required ParentRepository repository})
      : _repository = repository;

  Future<Resource<void>> call({
    required String itemId,
    required String tenantId,
  }) {
    return _repository.markAgendaItemAsRead(itemId: itemId, tenantId: tenantId);
  }
}

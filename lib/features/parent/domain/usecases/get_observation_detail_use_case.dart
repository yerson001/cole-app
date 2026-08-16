import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/parent/data/models/agenda_detail_model.dart';
import 'package:coleapp/features/parent/domain/repositories/parent_repository.dart';

class GetObservationDetailUseCase {
  final ParentRepository _repository;

  GetObservationDetailUseCase({required ParentRepository repository})
      : _repository = repository;

  Future<Resource<ObservationDetailModel>> call({
    required int observationId,
    required String tenantId,
  }) {
    return _repository.getObservationDetail(observationId, tenantId: tenantId);
  }
}
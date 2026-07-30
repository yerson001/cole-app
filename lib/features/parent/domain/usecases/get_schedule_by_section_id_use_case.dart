import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/parent/data/models/schedule_model.dart';
import 'package:coleapp/features/parent/domain/repositories/parent_repository.dart';

class GetScheduleBySectionIdUseCase {
  final ParentRepository _repository;

  GetScheduleBySectionIdUseCase({required ParentRepository repository})
      : _repository = repository;

  Future<Resource<List<ScheduleModel>>> call(int sectionId,
      {required String tenantId}) {
    return _repository.getScheduleBySectionId(sectionId, tenantId: tenantId);
  }
}

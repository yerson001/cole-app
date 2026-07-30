import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/parent/data/models/meeting_model.dart';
import 'package:coleapp/features/parent/domain/repositories/parent_repository.dart';

class GetMeetingsByParentUseCase {
  final ParentRepository _repository;

  GetMeetingsByParentUseCase({required ParentRepository repository})
      : _repository = repository;

  Future<Resource<List<ParentMeetingModel>>> call(int parentId,
      {required String tenantId}) {
    return _repository.getMeetingsByParent(parentId, tenantId: tenantId);
  }
}

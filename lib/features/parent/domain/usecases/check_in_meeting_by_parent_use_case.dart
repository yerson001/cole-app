import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/parent/domain/repositories/parent_repository.dart';

class CheckInMeetingByParentUseCase {
  final ParentRepository _repository;

  CheckInMeetingByParentUseCase({required ParentRepository repository})
      : _repository = repository;

  Future<Resource<void>> call({
    required int parentId,
    required int meetingId,
    required String tenantId,
  }) {
    return _repository.checkInMeetingByParent(
      parentId: parentId,
      meetingId: meetingId,
      tenantId: tenantId,
    );
  }
}

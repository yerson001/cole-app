import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/parent/data/models/agenda_detail_model.dart';
import 'package:coleapp/features/parent/domain/repositories/parent_repository.dart';

class GetAnnouncementDetailUseCase {
  final ParentRepository _repository;

  GetAnnouncementDetailUseCase({required ParentRepository repository})
      : _repository = repository;

  Future<Resource<AnnouncementDetailModel>> call({
    required int announcementId,
    required String tenantId,
  }) {
    return _repository.getAnnouncementDetail(announcementId, tenantId: tenantId);
  }
}
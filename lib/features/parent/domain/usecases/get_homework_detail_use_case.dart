import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/parent/data/models/agenda_detail_model.dart';
import 'package:coleapp/features/parent/domain/repositories/parent_repository.dart';

class GetHomeworkDetailUseCase {
  final ParentRepository _repository;

  GetHomeworkDetailUseCase({required ParentRepository repository})
      : _repository = repository;

  Future<Resource<HomeworkDetailModel>> call({
    required int homeworkId,
    required String tenantId,
  }) {
    return _repository.getHomeworkDetail(homeworkId, tenantId: tenantId);
  }
}
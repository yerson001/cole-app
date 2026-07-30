import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/parent/data/models/day_report_model.dart';
import 'package:coleapp/features/parent/domain/repositories/parent_repository.dart';

class GetDayReportUseCase {
  final ParentRepository _repository;

  GetDayReportUseCase({required ParentRepository repository})
      : _repository = repository;

  Future<Resource<List<DayReportModel>>> call({
    required String date,
    required int branchId,
    required List<int> studentIds,
    required String tenantId,
  }) {
    return _repository.getDayReport(
      date: date,
      branchId: branchId,
      studentIds: studentIds,
      tenantId: tenantId,
    );
  }
}

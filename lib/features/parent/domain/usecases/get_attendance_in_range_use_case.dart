import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/parent/data/models/day_report_model.dart';
import 'package:coleapp/features/parent/domain/repositories/parent_repository.dart';

class GetAttendanceInRangeUseCase {
  final ParentRepository _repository;

  GetAttendanceInRangeUseCase({required ParentRepository repository})
      : _repository = repository;

  Future<Resource<List<DayReportModel>>> call({
    required String startDate,
    required String endDate,
    required int branchId,
    required List<int> studentIds,
    required String tenantId,
  }) {
    return _repository.getAttendanceInRange(
      startDate: startDate,
      endDate: endDate,
      branchId: branchId,
      studentIds: studentIds,
      tenantId: tenantId,
    );
  }
}

import 'package:coleapp/features/parent/domain/usecases/clear_branch_use_case.dart';
import 'package:coleapp/features/parent/domain/usecases/get_branch_use_case.dart';

class ParentUseCases {
  final GetBranchUseCase getBranchUseCase;
  final ClearBranchUseCase clearBranchUseCase;

  ParentUseCases({
    required this.getBranchUseCase,
    required this.clearBranchUseCase,
  });
}

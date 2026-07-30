import 'package:coleapp/features/auth/data/models/user.dart';
import 'package:coleapp/features/parent/data/models/branch_model.dart';
import 'package:equatable/equatable.dart';

class ParentHomeState extends Equatable {
  final int pageIndex;
  final int previousPageIndex;
  final User? user;
  final BranchModel? branch;

  const ParentHomeState({this.pageIndex = 0, this.previousPageIndex = 0, this.user, this.branch});

  ParentHomeState copyWith({int? pageIndex, int? previousPageIndex, User? user, BranchModel? branch}) {
    return ParentHomeState(
      pageIndex: pageIndex ?? this.pageIndex,
      previousPageIndex: previousPageIndex ?? this.previousPageIndex,
      user: user ?? this.user,
      branch: branch ?? this.branch,
    );
  }

  @override
  List<Object?> get props => [pageIndex, previousPageIndex, user, branch];
}

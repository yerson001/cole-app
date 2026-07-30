import 'package:coleapp/features/auth/data/models/user.dart';
import 'package:coleapp/features/parent/data/models/branch_model.dart';
import 'package:equatable/equatable.dart';

class ParentHomeState extends Equatable {
  final int pageIndex;
  final User? user;
  final BranchModel? branch;

  const ParentHomeState({this.pageIndex = 0, this.user, this.branch});

  ParentHomeState copyWith({int? pageIndex, User? user, BranchModel? branch}) {
    return ParentHomeState(
      pageIndex: pageIndex ?? this.pageIndex,
      user: user ?? this.user,
      branch: branch ?? this.branch,
    );
  }

  @override
  List<Object?> get props => [pageIndex, user, branch];
}

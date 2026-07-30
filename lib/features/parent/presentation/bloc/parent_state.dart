import 'package:coleapp/features/auth/data/models/user.dart';
import 'package:equatable/equatable.dart';

class ParentState extends Equatable {
  final int pageIndex;
  final User? user;

  const ParentState({this.pageIndex = 0, this.user});

  ParentState copyWith({int? pageIndex, User? user}) {
    return ParentState(
      pageIndex: pageIndex ?? this.pageIndex,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [pageIndex,user];
}

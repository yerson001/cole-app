import 'package:equatable/equatable.dart';

class ParentState extends Equatable {
  final int pageIndex;

  const ParentState({this.pageIndex = 0});

  ParentState copyWith({int? pageIndex}) {
    return ParentState(pageIndex: pageIndex ?? this.pageIndex);
  }

  @override
  List<Object?> get props => [pageIndex];
}

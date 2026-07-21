import 'package:equatable/equatable.dart';

class DirectorState extends Equatable {
  final int pageIndex;

  const DirectorState({this.pageIndex = 0});

  DirectorState copyWith({int? pageIndex}) {
    return DirectorState(pageIndex: pageIndex ?? this.pageIndex);
  }

  @override
  List<Object?> get props => [pageIndex];
}

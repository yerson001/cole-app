import 'package:equatable/equatable.dart';

class TeacherState extends Equatable {
  final int pageIndex;

  const TeacherState({this.pageIndex = 0});

  TeacherState copyWith({int? pageIndex}) {
    return TeacherState(pageIndex: pageIndex ?? this.pageIndex);
  }

  @override
  List<Object?> get props => [pageIndex];
}

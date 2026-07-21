import 'package:equatable/equatable.dart';

class AssistantState extends Equatable {
  final int pageIndex;

  const AssistantState({this.pageIndex = 0});

  AssistantState copyWith({int? pageIndex}) {
    return AssistantState(pageIndex: pageIndex ?? this.pageIndex);
  }

  @override
  List<Object?> get props => [pageIndex];
}

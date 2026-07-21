import 'package:equatable/equatable.dart';

class SecretaryState extends Equatable {
  final int pageIndex;

  const SecretaryState({this.pageIndex = 0});

  SecretaryState copyWith({int? pageIndex}) {
    return SecretaryState(pageIndex: pageIndex ?? this.pageIndex);
  }

  @override
  List<Object?> get props => [pageIndex];
}

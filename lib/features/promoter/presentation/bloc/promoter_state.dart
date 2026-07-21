import 'package:equatable/equatable.dart';

class PromoterState extends Equatable {
  final int pageIndex;

  const PromoterState({this.pageIndex = 0});

  PromoterState copyWith({int? pageIndex}) {
    return PromoterState(pageIndex: pageIndex ?? this.pageIndex);
  }

  @override
  List<Object?> get props => [pageIndex];
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class FotocheckEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FotocheckState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FotocheckBloc extends Bloc<FotocheckEvent, FotocheckState> {
  FotocheckBloc() : super(FotocheckState()) {
    on<FotocheckEvent>((event, emit) {});
  }
}

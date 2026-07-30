import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class ReunionesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReunionesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReunionesBloc extends Bloc<ReunionesEvent, ReunionesState> {
  ReunionesBloc() : super(ReunionesState()) {
    on<ReunionesEvent>((event, emit) {});
  }
}

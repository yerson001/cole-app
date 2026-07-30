import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class CuotasEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CuotasState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CuotasBloc extends Bloc<CuotasEvent, CuotasState> {
  CuotasBloc() : super(CuotasState()) {
    on<CuotasEvent>((event, emit) {});
  }
}

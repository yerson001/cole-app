import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class PensionesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PensionesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PensionesBloc extends Bloc<PensionesEvent, PensionesState> {
  PensionesBloc() : super(PensionesState()) {
    on<PensionesEvent>((event, emit) {});
  }
}

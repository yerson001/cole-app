import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class HorarioEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class HorarioState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HorarioBloc extends Bloc<HorarioEvent, HorarioState> {
  HorarioBloc() : super(HorarioState()) {
    on<HorarioEvent>((event, emit) {});
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class CalificacionesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CalificacionesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CalificacionesBloc extends Bloc<CalificacionesEvent, CalificacionesState> {
  CalificacionesBloc() : super(CalificacionesState()) {
    on<CalificacionesEvent>((event, emit) {});
  }
}

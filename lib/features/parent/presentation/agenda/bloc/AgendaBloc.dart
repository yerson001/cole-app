import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class AgendaEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AgendaState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AgendaBloc extends Bloc<AgendaEvent, AgendaState> {
  AgendaBloc() : super(AgendaState()) {
    on<AgendaEvent>((event, emit) {});
  }
}

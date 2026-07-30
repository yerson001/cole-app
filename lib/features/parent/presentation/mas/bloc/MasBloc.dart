import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class MasEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class MasState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MasBloc extends Bloc<MasEvent, MasState> {
  MasBloc() : super(MasState()) {
    on<MasEvent>((event, emit) {});
  }
}

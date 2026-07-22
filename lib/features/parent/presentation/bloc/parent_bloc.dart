import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:coleapp/features/parent/presentation/bloc/parent_event.dart';
import 'package:coleapp/features/parent/presentation/bloc/parent_state.dart';

class ParentBloc extends Bloc<ParentEvent, ParentState> {
  final AuthUseCases authUseCases;

  ParentBloc(this.authUseCases) : super(const ParentState()) {
    on<Logout>((event, emit) async {
      await authUseCases.logoutUseCase.call();
    });
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:coleapp/features/director/presentation/bloc/director_event.dart';
import 'package:coleapp/features/director/presentation/bloc/director_state.dart';

class DirectorBloc extends Bloc<DirectorEvent, DirectorState> {
  final AuthUseCases authUseCases;

  DirectorBloc(this.authUseCases) : super(const DirectorState()) {
    on<ChangeDrawerPage>((event, emit) {
      emit(state.copyWith(pageIndex: event.pageIndex));
    });

    on<Logout>((event, emit) async {
      await authUseCases.logoutUseCase.call();
      emit(state.copyWith(pageIndex: 0));
    });
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:coleapp/features/secretary/presentation/bloc/secretary_event.dart';
import 'package:coleapp/features/secretary/presentation/bloc/secretary_state.dart';

class SecretaryBloc extends Bloc<SecretaryEvent, SecretaryState> {
  final AuthUseCases authUseCases;

  SecretaryBloc(this.authUseCases) : super(const SecretaryState()) {
    on<ChangeDrawerPage>((event, emit) {
      emit(state.copyWith(pageIndex: event.pageIndex));
    });

    on<Logout>((event, emit) async {
      await authUseCases.logoutUseCase.call();
      emit(state.copyWith(pageIndex: 0));
    });
  }
}

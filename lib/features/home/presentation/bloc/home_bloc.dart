import 'package:coleapp/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:coleapp/features/home/presentation/bloc/home_event.dart';
import 'package:coleapp/features/home/presentation/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger('HOME_BLOC');

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AuthUseCases authUseCases;

  HomeBloc(this.authUseCases) : super(const HomeState()) {
    on<LoadHomeSession>((event, emit) async {
      _log.info('LoadHomeSession');
      emit(state.copyWith(isLoading: true));
      final session = await authUseCases.getusersessionUseCase.call();
      if (session != null) {
        final token = session.token;
        final preview = token.length > 20
            ? '${token.substring(0, 20)}...'
            : token;
        emit(state.copyWith(
          role: session.user.profile?.type ?? 'Sin rol',
          tenant: session.tenant,
          tokenPreview: preview,
          isLoading: false,
        ));
        _log.info('rol=${state.role} tenant=${state.tenant}');
      } else {
        emit(state.copyWith(
          role: 'Sin sesión',
          isLoading: false,
        ));
      }
    });

    on<LogoutRequested>((event, emit) async {
      _log.info('LogoutRequested');
      await authUseCases.logoutUseCase.call();
      emit(state.copyWith(loggedOut: true));
    });
  }
}

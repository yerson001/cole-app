import 'package:coleapp/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:coleapp/features/splash/presentation/bloc/splash_event.dart';
import 'package:coleapp/features/splash/presentation/bloc/splash_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger('SPLASH_BLOC');

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AuthUseCases authUseCases;

  SplashBloc(this.authUseCases) : super(SplashInitial()) {
    on<CheckSplashSession>((event, emit) async {
      _log.info('CheckSplashSession');
      final session = await authUseCases.getusersessionUseCase.call();
      if (session != null) {
        _log.info('Sesión activa');
        emit(SplashSessionFound());
      } else {
        _log.info('Sin sesión');
        emit(SplashSessionNotFound());
      }
    });
  }
}

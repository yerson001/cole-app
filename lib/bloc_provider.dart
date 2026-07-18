import 'package:coleapp/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:coleapp/features/auth/presentation/bloc/login_bloc.dart';
import 'package:coleapp/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger('DI');

List<BlocProvider> blocProviders = [
  BlocProvider<LoginBloc>(
    create: (context) {
      _log.info('Creando LoginBloc');
      final instance = LoginBloc(getIt<AuthUseCases>());
      _log.info('LoginBloc creado');
      return instance;
    },
  ),
];

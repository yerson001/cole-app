import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:coleapp/features/auth/presentation/login/bloc/login_bloc.dart';
import 'package:coleapp/features/auth/presentation/login/bloc/login_event.dart';
import 'package:coleapp/injection.dart';

List<BlocProvider> blocProviders = [
  BlocProvider<LoginBloc>(
    create: (context) =>
        LoginBloc(getIt<AuthUseCases>())..add(LoginInit()),
  ),
];

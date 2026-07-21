import 'package:coleapp/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:coleapp/features/auth/presentation/bloc/login_bloc.dart';
import 'package:coleapp/features/home/presentation/bloc/home_bloc.dart';
import 'package:coleapp/features/roles/presentation/bloc/roles_bloc.dart';
import 'package:coleapp/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:coleapp/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<BlocProvider> blocProviders = [
  BlocProvider<LoginBloc>(
    create: (context) => LoginBloc(locator<AuthUseCases>()),
  ),
  BlocProvider<SplashBloc>(
    create: (context) => SplashBloc(locator<AuthUseCases>()),
  ),
  BlocProvider<HomeBloc>(
    create: (context) => HomeBloc(locator<AuthUseCases>()),
  ),
  BlocProvider<RolesBloc>(
    create: (context) => RolesBloc(locator<AuthUseCases>()),
  ),
];

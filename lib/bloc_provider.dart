import 'package:coleapp/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:coleapp/features/auth/presentation/bloc/login_bloc.dart';
import 'package:coleapp/features/roles/presentation/bloc/roles_bloc.dart';
import 'package:coleapp/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:coleapp/features/director/presentation/bloc/director_bloc.dart';
import 'package:coleapp/features/promoter/presentation/bloc/promoter_bloc.dart';
import 'package:coleapp/features/secretary/presentation/bloc/secretary_bloc.dart';
import 'package:coleapp/features/assistant/presentation/bloc/assistant_bloc.dart';
import 'package:coleapp/features/teacher/presentation/bloc/teacher_bloc.dart';
import 'package:coleapp/features/parent/presentation/bloc/parent_bloc.dart';
import 'package:coleapp/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<BlocProvider> blocProviders = [
  BlocProvider<LoginBloc>(
    create: (context) => LoginBloc(locator<AuthUseCases>()),
  ),
  BlocProvider<SplashBloc>(
    create: (context) => SplashBloc(locator<AuthUseCases>()),
  ),
  BlocProvider<RolesBloc>(
    create: (context) => RolesBloc(locator<AuthUseCases>()),
  ),
  BlocProvider<DirectorBloc>(
    create: (context) => DirectorBloc(locator<AuthUseCases>()),
  ),
  BlocProvider<PromoterBloc>(
    create: (context) => PromoterBloc(locator<AuthUseCases>()),
  ),
  BlocProvider<SecretaryBloc>(
    create: (context) => SecretaryBloc(locator<AuthUseCases>()),
  ),
  BlocProvider<AssistantBloc>(
    create: (context) => AssistantBloc(locator<AuthUseCases>()),
  ),
  BlocProvider<TeacherBloc>(
    create: (context) => TeacherBloc(locator<AuthUseCases>()),
  ),
  BlocProvider<ParentBloc>(
    create: (context) => ParentBloc(locator<AuthUseCases>()),
  ),
];

// ────────────────────────────────────────────────────────────
// PRESENTATION LAYER — BLoC (Business Logic Component)
// ────────────────────────────────────────────────────────────
// El BLoC es el CEREBRO de la pantalla de login.
//
// ¿Qué hace?
//   1. Recibe EVENTOS del usuario (escribió, apretó botón, etc.)
//   2. Ejecuta LÓGICA (validar, llamar use cases, etc.)
//   3. Emite ESTADOS nuevos para que la UI se actualice
//
// ¿Qué NO hace?
//   - No sabe de HTTP (eso es trabajo de AuthService)
//   - No sabe de SharedPreferences (eso es trabajo de AuthLocalStorage)
//   - No muestra nada en pantalla (eso es trabajo de los widgets)
//
// El BLoC recibe AUTHUSECASES por constructor.
// AuthUseCases es una "mochila" que contiene todos los use cases.
//
// ¿Quién crea el BLoC?
//   - BlocProvider (en bloc_provider.dart)
//   - Allí se le inyecta getIt<AuthUseCases>() — el baúl se lo da
//
// FLUJO COMPLETO:
//   LoginContent → LoginSubmit(evento) → LoginBloc → authUseCases.loginUseCase.call()
//     → LoginUseCase → authRepository.login()
//       → AuthRepositoryImpl → AuthService.login() [HTTP]
//       → AuthRepositoryImpl → AuthLocalStorage.save() [disco si aplica]
//     → resultado vuelve → BLoC emite estado → UI se actualiza
// ────────────────────────────────────────────────────────────

import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/auth/data/models/auth_response.dart';
import 'package:coleapp/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:coleapp/features/auth/presentation/bloc/login_event.dart';
import 'package:coleapp/features/auth/presentation/bloc/login_state.dart';
import 'package:coleapp/shared/utils/bloc_form_item.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger('BLOC');

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final formKey = GlobalKey<FormState>();

  // ── ÚNICA DEPENDENCIA ─────────────────────────────────────
  // AuthUseCases es la mochila con todos los use cases adentro.
  // La recibe por constructor (se la pasa BlocProvider).
  final AuthUseCases authUseCases;

  LoginBloc(this.authUseCases) : super(const LoginState()) {
    // ── MANEJADORES DE EVENTOS ──────────────────────────────
    // Cada "on<TipoEvento>" escucha un evento y decide qué hacer.

    on<LoginInit>((event, emit) {
      _log.info('LoginInit');
      emit(state.copyWith(formKey: formKey));
    });

    on<LoadSavedData>((event, emit) async {
      _log.info('LoadSavedData');
      final tenant = await authUseCases.getusersessionUseCase.authRepository
          .getSavedTenant();
      final creds =
          await authUseCases.getusersessionUseCase.authRepository
              .getSavedCredentials();
      final rememberMe = creds != null;
      emit(state.copyWith(
        tenant: BlocFormItem(value: tenant ?? ''),
        username: BlocFormItem(value: creds?['username'] ?? ''),
        password: BlocFormItem(value: creds?['password'] ?? ''),
        rememberMe: rememberMe,
        formKey: formKey,
      ));
    });

    on<TenantChanged>((event, emit) {
      final v = event.tenant.trim();
      _log.info('TenantChanged: "$v"');
      emit(state.copyWith(
        tenant: BlocFormItem(value: v),
        formKey: formKey,
      ));
    });

    on<UsernameChanged>((event, emit) {
      final v = event.username.trim();
      _log.info('UsernameChanged: "$v"');
      emit(state.copyWith(
        username: BlocFormItem(value: v),
        formKey: formKey,
      ));
    });

    on<PasswordChanged>((event, emit) {
      _log.info('PasswordChanged: "${event.password}"');
      emit(state.copyWith(
        password: BlocFormItem(value: event.password),
        formKey: formKey,
      ));
    });

    on<RememberMeChanged>((event, emit) {
      _log.info('RememberMeChanged: ${event.rememberMe}');
      emit(state.copyWith(rememberMe: event.rememberMe, formKey: formKey));
    });

    on<LoginSubmit>((event, emit) async {
      final tenantTrimmed = state.tenant.value.trim();
      final usernameTrimmed = state.username.value.trim();
      _log.info('LoginSubmit: tenant=[$tenantTrimmed] username=[$usernameTrimmed]');
      emit(state.copyWith(response: LoadingResource(), formKey: formKey));

      try {
        final result = await authUseCases.loginUseCase.call(
          tenantTrimmed,
          usernameTrimmed,
          state.password.value,
        );

        if (result is SuccessResource) {
          final authResponse = (result as SuccessResource<AuthResponse>).data;
          _log.info('Success: token=${authResponse.token} roles=${authResponse.user.roles}');
        } else if (result is ErrorResource) {
          final errMsg = (result as ErrorResource).message;
          _log.warning('Error: $errMsg');
        }
        emit(state.copyWith(response: result, formKey: formKey));
      } catch (e) {
        _log.severe('Excepción en submit: $e');
        emit(state.copyWith(
          response: ErrorResource(e.toString()),
          formKey: formKey,
        ));
      }
    });

    on<SaveSession>((event, emit) async {
      _log.info('SaveSession: rememberMe=${event.rememberMe}');
      await authUseCases.saveuserUseCase.call(
        event.authResponse,
        rememberMe: event.rememberMe,
      );
      _log.info('Sesión guardada');
    });

    on<ResetLogin>((event, emit) {
      _log.info('ResetLogin');
      emit(state.copyWith(response: null));
    });
  }
}

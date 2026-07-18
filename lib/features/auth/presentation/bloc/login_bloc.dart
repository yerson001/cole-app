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
  final AuthUseCases authUseCases;

  LoginBloc(this.authUseCases) : super(const LoginState()) {
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
      _log.info('LoginSubmit: tenant=[$tenantTrimmed] username=[$usernameTrimmed] password=[${state.password.value}]');
      emit(state.copyWith(response: LoadingResource(), formKey: formKey));

      try {
        final result = await authUseCases.loginUseCase.call(
          tenantTrimmed,
          usernameTrimmed,
          state.password.value,
        );
        _log.info('Resultado: ${result.runtimeType}');
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
  }
}

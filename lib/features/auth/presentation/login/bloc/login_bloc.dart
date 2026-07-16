import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:coleapp/features/auth/presentation/login/bloc/login_event.dart';
import 'package:coleapp/features/auth/presentation/login/bloc/login_state.dart';
import 'package:coleapp/shared/utils/bloc_form_item.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final formKey = GlobalKey<FormState>();
  final AuthUseCases authUseCases;

  LoginBloc(this.authUseCases) : super(LoginState()) {
    on<LoginInit>((event, emit) async {
      emit(state.copyWith(formKey: formKey));
      final session = await authUseCases.getSession.run();
      if (session != null) {
        emit(state.copyWith(
          response: SuccessResource(session),
          formKey: formKey,
        ));
      } else {
        final savedTenant = authUseCases.getTenantKey.run();
        if (savedTenant != null && savedTenant.isNotEmpty) {
          emit(state.copyWith(
            tenantKey: BlocFormItem(value: savedTenant),
            formKey: formKey,
          ));
        }
      }
    });

    on<DniChanged>((event, emit) {
      emit(state.copyWith(
        dni: BlocFormItem(
          value: event.dni.value,
          error: event.dni.value.isEmpty
              ? 'Ingrese su DNI'
              : event.dni.value.length < 8
                  ? 'DNI debe tener 8 dígitos'
                  : null,
        ),
        formKey: formKey,
      ));
    });

    on<PasswordChanged>((event, emit) {
      emit(state.copyWith(
        password: BlocFormItem(
          value: event.password.value,
          error: event.password.value.isEmpty
              ? 'Ingrese su contraseña'
              : null,
        ),
        formKey: formKey,
      ));
    });

    on<TenantKeyChanged>((event, emit) {
      emit(state.copyWith(
        tenantKey: BlocFormItem(
          value: event.tenantKey.value,
          error: event.tenantKey.value.isEmpty
              ? 'Ingrese el código del colegio'
              : null,
        ),
        formKey: formKey,
      ));
    });

    on<SaveSession>((event, emit) async {
      await authUseCases.save.run(event.authResponse);
    });

    on<FormSubmitted>((event, emit) async {
      emit(state.copyWith(response: LoadingResource(), formKey: formKey));
      final Resource response = await authUseCases.login.run(
        state.dni.value,
        state.password.value,
        state.tenantKey.value,
      );
      emit(state.copyWith(response: response, formKey: formKey));
    });
  }
}

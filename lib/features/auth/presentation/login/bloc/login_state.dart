import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/shared/utils/bloc_form_item.dart';

class LoginState extends Equatable {
  final BlocFormItem dni;
  final BlocFormItem password;
  final BlocFormItem tenantKey;
  final GlobalKey<FormState>? formKey;
  final Resource? response;

  const LoginState({
    this.dni = const BlocFormItem(error: 'Ingrese su DNI'),
    this.password = const BlocFormItem(error: 'Ingrese su contraseña'),
    this.tenantKey = const BlocFormItem(error: 'Ingrese el código del colegio'),
    this.formKey,
    this.response,
  });

  LoginState copyWith({
    BlocFormItem? dni,
    BlocFormItem? password,
    BlocFormItem? tenantKey,
    GlobalKey<FormState>? formKey,
    Resource? response,
  }) {
    return LoginState(
      dni: dni ?? this.dni,
      password: password ?? this.password,
      tenantKey: tenantKey ?? this.tenantKey,
      formKey: formKey ?? this.formKey,
      response: response,
    );
  }

  @override
  List<Object?> get props => [formKey, dni, password, tenantKey, response];
}

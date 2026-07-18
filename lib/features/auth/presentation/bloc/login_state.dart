import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/shared/utils/bloc_form_item.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class LoginState extends Equatable{
  final BlocFormItem tenant;
  final BlocFormItem username;
  final BlocFormItem password;
  final bool rememberMe;
  final GlobalKey<FormState>? formKey;
  final Resource? response;  

  const LoginState({
    this.tenant = const BlocFormItem(error: 'Tenant is required'),
    this.username = const BlocFormItem(error: 'Username is required'),
    this.password = const BlocFormItem(error: 'Password is required'),
    this.rememberMe = false,
    this.formKey,
    this.response,
  });


  LoginState copyWith({
    BlocFormItem? tenant,
    BlocFormItem? username,
    BlocFormItem? password,
    bool? rememberMe,
    GlobalKey<FormState>? formKey,
    Resource? response,
  }) {
    return LoginState(
      tenant: tenant ?? this.tenant,
      username: username ?? this.username,
      password: password ?? this.password,
      rememberMe: rememberMe ?? this.rememberMe,
      formKey: formKey ?? this.formKey,
      response: response ?? this.response,
    );
  }

  @override
  List<Object?> get props => [
        tenant,
        username,
        password,
        rememberMe,
        formKey,
        response,
      ]; 
}
import 'package:coleapp/features/auth/data/models/auth_response.dart';
import 'package:coleapp/shared/utils/bloc_form_item.dart';

abstract class LoginEvent {}

class LoginInit extends LoginEvent {}

class DniChanged extends LoginEvent {
  final BlocFormItem dni;
  DniChanged({required this.dni});
}

class PasswordChanged extends LoginEvent {
  final BlocFormItem password;
  PasswordChanged({required this.password});
}

class TenantKeyChanged extends LoginEvent {
  final BlocFormItem tenantKey;
  TenantKeyChanged({required this.tenantKey});
}

class SaveSession extends LoginEvent {
  final AuthResponse authResponse;
  SaveSession({required this.authResponse});
}

class FormSubmitted extends LoginEvent {}

import 'package:coleapp/features/auth/data/models/auth_response.dart';

abstract class LoginEvent {}

class LoginInit extends LoginEvent {}

class LoadSavedData extends LoginEvent {}

class TenantChanged extends LoginEvent {
  final String tenant;
  TenantChanged(this.tenant);
}

class UsernameChanged extends LoginEvent {
  final String username;
  UsernameChanged(this.username);
}

class PasswordChanged extends LoginEvent {
  final String password;
  PasswordChanged(this.password);
}

class RememberMeChanged extends LoginEvent {
  final bool rememberMe;
  RememberMeChanged(this.rememberMe);
}

class LoginSubmit extends LoginEvent {}

class SaveSession extends LoginEvent {
  final AuthResponse authResponse;
  final bool rememberMe;
  SaveSession(this.authResponse, this.rememberMe);
}

class ResetLogin extends LoginEvent {}



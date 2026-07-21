import 'package:equatable/equatable.dart';
import 'package:coleapp/features/auth/data/models/auth_response.dart';

abstract class SplashState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {}

class SplashSessionFound extends SplashState {
  final AuthResponse authResponse;
  SplashSessionFound(this.authResponse);

  @override
  List<Object?> get props => [authResponse];
}

class SplashSessionNotFound extends SplashState {}

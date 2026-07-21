import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {}

class SplashSessionFound extends SplashState {}

class SplashSessionNotFound extends SplashState {}

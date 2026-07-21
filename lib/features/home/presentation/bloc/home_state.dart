import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final String role;
  final String tenant;
  final String tokenPreview;
  final bool isLoading;
  final bool loggedOut;

  const HomeState({
    this.role = '',
    this.tenant = '',
    this.tokenPreview = '',
    this.isLoading = true,
    this.loggedOut = false,
  });

  HomeState copyWith({
    String? role,
    String? tenant,
    String? tokenPreview,
    bool? isLoading,
    bool? loggedOut,
  }) {
    return HomeState(
      role: role ?? this.role,
      tenant: tenant ?? this.tenant,
      tokenPreview: tokenPreview ?? this.tokenPreview,
      isLoading: isLoading ?? this.isLoading,
      loggedOut: loggedOut ?? this.loggedOut,
    );
  }

  @override
  List<Object?> get props => [role, tenant, tokenPreview, isLoading, loggedOut];
}

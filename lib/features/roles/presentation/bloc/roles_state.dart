import 'package:equatable/equatable.dart';
import 'package:coleapp/features/auth/data/models/role.dart';

class RolesState extends Equatable {
  final List<Role>? roles;

  const RolesState({this.roles});

  RolesState copyWith({List<Role>? roles}) {
    return RolesState(roles: roles ?? this.roles);
  }

  @override
  List<Object?> get props => [roles];
}

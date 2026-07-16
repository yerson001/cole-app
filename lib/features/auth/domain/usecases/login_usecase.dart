import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Resource> run(String dni, String password, String tenantKey) =>
      repository.login(dni, password, tenantKey);
}

import 'package:coleapp/features/auth/domain/repositories/auth_repository.dart';

class GetTenantKeyUseCase {
  final AuthRepository authRepository;

  GetTenantKeyUseCase(this.authRepository);

  String? run() => authRepository.getTenantKey();
}

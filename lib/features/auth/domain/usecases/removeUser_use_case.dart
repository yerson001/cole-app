import 'package:coleapp/features/auth/domain/repositories/auth_repository.dart';

class RemoveuserUseCase {
  final AuthRepository authRepository;

  RemoveuserUseCase(this.authRepository);

  Future<void> call() async {
    return await authRepository.removeUserSession();
  }
}

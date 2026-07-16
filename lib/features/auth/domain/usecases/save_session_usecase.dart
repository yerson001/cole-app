import 'package:coleapp/features/auth/data/models/auth_response.dart';
import 'package:coleapp/features/auth/domain/repositories/auth_repository.dart';

class SaveSessionUseCase {
  final AuthRepository authRepository;

  SaveSessionUseCase(this.authRepository);

  Future<void> run(AuthResponse authResponse) async {
    return authRepository.saveUserSession(authResponse);
  }
}

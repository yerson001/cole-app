import 'package:coleapp/features/auth/data/models/auth_response.dart';
import 'package:coleapp/features/auth/domain/repositories/auth_repository.dart';

class SaveuserUseCase {
  final AuthRepository authRepository;

  SaveuserUseCase(this.authRepository);

  Future<void> call(AuthResponse authResponse, {bool rememberMe = false}) async {
    return await authRepository.saveUserSession(authResponse, rememberMe: rememberMe);
  }
}
import 'package:coleapp/features/auth/data/models/auth_response.dart';
import 'package:coleapp/features/auth/domain/repositories/auth_repository.dart';

class GetSessionUseCase {
  final AuthRepository authRepository;

  GetSessionUseCase(this.authRepository);

  Future<AuthResponse?> run() async {
    return authRepository.getUserSession();
  }
}

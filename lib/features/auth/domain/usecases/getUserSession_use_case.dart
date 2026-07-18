import 'package:coleapp/features/auth/data/models/auth_response.dart';
import 'package:coleapp/features/auth/domain/repositories/auth_repository.dart';

class GetusersessionUseCase {
  final AuthRepository authRepository;

  GetusersessionUseCase(this.authRepository);

  Future<AuthResponse?> call() async {
    return await authRepository.getUserSession();
  }
}

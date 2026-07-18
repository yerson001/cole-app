import 'package:coleapp/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository autRepository;

  LogoutUseCase(this.autRepository);

  Future<bool> call() async {
    return await autRepository.logout(); 
  }
}

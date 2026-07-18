import 'package:coleapp/features/auth/domain/usecases/getUserSession_use_case.dart';
import 'package:coleapp/features/auth/domain/usecases/login_use_case.dart';
import 'package:coleapp/features/auth/domain/usecases/logout_use_case.dart';
import 'package:coleapp/features/auth/domain/usecases/removeUser_use_case.dart';
import 'package:coleapp/features/auth/domain/usecases/saveUser_use_case.dart';

class AuthUseCases {
  final LoginUseCase loginUseCase;
  final SaveuserUseCase saveuserUseCase;
  final GetusersessionUseCase getusersessionUseCase;
  final RemoveuserUseCase removeuserUseCase;
  final LogoutUseCase logoutUseCase;


AuthUseCases({
  required this.loginUseCase,
  required this.saveuserUseCase,
  required this.getusersessionUseCase,
  required this.removeuserUseCase,
  required this.logoutUseCase,
});
}
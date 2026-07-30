import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:coleapp/features/profile/presentation/screens/info/bloc/profile_info_event.dart';
import 'package:coleapp/features/profile/presentation/screens/info/bloc/profile_info_state.dart';

class ProfileInfoBloc extends Bloc<ProfileInfoEvent, ProfileInfoState> {
  final AuthUseCases authUseCases;

  ProfileInfoBloc(this.authUseCases) : super(const ProfileInfoState()) {
    on<GetUserInfo>((event, emit) async {
      final session = await authUseCases.getusersessionUseCase.call();
      if (session != null) {
        emit(state.copyWith(user: session.user));
      }
    });

    on<OutLogInfo>((event, emit) async {
      await authUseCases.logoutUseCase.call();
    });
  }
}

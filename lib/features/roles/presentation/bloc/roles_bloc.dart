import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/features/auth/data/models/auth_response.dart';
import 'package:coleapp/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:coleapp/features/roles/presentation/bloc/roles_event.dart';
import 'package:coleapp/features/roles/presentation/bloc/roles_state.dart';

class RolesBloc extends Bloc<RolesEvent, RolesState> {
  AuthUseCases authUseCases;

  RolesBloc(this.authUseCases) : super(RolesState()) {
    on<GetRolesList>((event, emit) async {
      AuthResponse? authResponse = await authUseCases.getusersessionUseCase.call();
      emit(state.copyWith(roles: authResponse?.user.roles));
    });
  }
}

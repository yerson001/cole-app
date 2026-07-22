import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:coleapp/features/assistant/presentation/bloc/assistant_event.dart';
import 'package:coleapp/features/assistant/presentation/bloc/assistant_state.dart';

class AssistantBloc extends Bloc<AssistantEvent, AssistantState> {
  final AuthUseCases authUseCases;

  AssistantBloc(this.authUseCases) : super(const AssistantState()) {
    on<Logout>((event, emit) async {
      await authUseCases.logoutUseCase.call();
    });
  }
}

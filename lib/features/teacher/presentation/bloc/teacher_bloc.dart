import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:coleapp/features/teacher/presentation/bloc/teacher_event.dart';
import 'package:coleapp/features/teacher/presentation/bloc/teacher_state.dart';

class TeacherBloc extends Bloc<TeacherEvent, TeacherState> {
  final AuthUseCases authUseCases;

  TeacherBloc(this.authUseCases) : super(const TeacherState()) {
    on<ChangeDrawerPage>((event, emit) {
      emit(state.copyWith(pageIndex: event.pageIndex));
    });

    on<Logout>((event, emit) async {
      await authUseCases.logoutUseCase.call();
      emit(state.copyWith(pageIndex: 0));
    });
  }
}

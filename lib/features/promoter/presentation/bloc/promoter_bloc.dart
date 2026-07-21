import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:coleapp/features/promoter/presentation/bloc/promoter_event.dart';
import 'package:coleapp/features/promoter/presentation/bloc/promoter_state.dart';

class PromoterBloc extends Bloc<PromoterEvent, PromoterState> {
  final AuthUseCases authUseCases;

  PromoterBloc(this.authUseCases) : super(const PromoterState()) {
    on<ChangeDrawerPage>((event, emit) {
      emit(state.copyWith(pageIndex: event.pageIndex));
    });

    on<Logout>((event, emit) async {
      await authUseCases.logoutUseCase.call();
      emit(state.copyWith(pageIndex: 0));
    });
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:coleapp/features/parent/data/models/branch_model.dart';
import 'package:coleapp/features/parent/domain/usecases/parent_use_cases.dart';
import 'package:coleapp/features/parent/presentation/home/bloc/ParentHomeEvent.dart';
import 'package:coleapp/features/parent/presentation/home/bloc/ParentHomeState.dart';

class ParentHomeBloc extends Bloc<ParentHomeEvent, ParentHomeState> {
  final AuthUseCases authUseCases;
  final ParentUseCases parentUseCases;

  ParentHomeBloc(this.authUseCases, this.parentUseCases) : super(const ParentHomeState()) {
    on<ChangePage>((event, emit) {
      emit(state.copyWith(
        pageIndex: event.pageIndex,
        previousPageIndex: state.pageIndex,
      ));
    });

    on<GetParentUser>((event, emit) async {
      final session = await authUseCases.getusersessionUseCase.call();
      if (session != null) {
        emit(state.copyWith(user: session.user));
      }
    });

    on<GetBranch>((event, emit) async {
      final result = await parentUseCases.getBranchUseCase
          .call(event.id, tenantId: event.tenantId);
      if (result is SuccessResource<BranchModel>) {
        emit(state.copyWith(branch: result.data));
      }
    });

    on<Logout>((event, emit) async {
      await parentUseCases.clearBranchUseCase.call();
      await authUseCases.logoutUseCase.call();
    });
  }
}

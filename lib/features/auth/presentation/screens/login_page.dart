import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/auth/data/models/auth_response.dart';
import 'package:coleapp/features/auth/presentation/bloc/login_bloc.dart';
import 'package:coleapp/features/auth/presentation/bloc/login_event.dart';
import 'package:coleapp/features/auth/presentation/bloc/login_state.dart';
import 'package:coleapp/features/auth/presentation/screens/login_content.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
      listener: (context, state) async {
        final response = state.response;
        if (response is SuccessResource) {
          final authResponse = response.data as AuthResponse;
          await context.read<LoginBloc>().authUseCases.saveuserUseCase.call(
            authResponse,
            rememberMe: state.rememberMe,
          );
          if (!context.mounted) return;
          if (authResponse.user.roles.isEmpty) {
            context.read<LoginBloc>().add(ResetLogin());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No se encontraron roles. Intente de nuevo.'),
              ),
            );
            return;
          }
          if (authResponse.user.roles.length > 1) {
            Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
          } else {
            Navigator.pushNamedAndRemoveUntil(
              context,
              authResponse.user.roles.first.route,
              (route) => false,
            );
          }
        }
      },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            if (state.response is LoadingResource) {
              return const Center(child: CircularProgressIndicator());
            }
            return const LoginContent();
          },
        ),
      ),
    );
  }
}

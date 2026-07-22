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
        listener: (context, state) {
          final response = state.response;
          if (response is SuccessResource) {
            final authResponse = response.data as AuthResponse;
            context.read<LoginBloc>().add(SaveSession(authResponse, state.rememberMe));
            if (authResponse.user.roles.length > 1) {
              Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
            } else {
              Navigator.pushNamedAndRemoveUntil(context, authResponse.user.roles.first.route, (route) => false);
            }
          } else if (response is ErrorResource) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(response.message)),
            );
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

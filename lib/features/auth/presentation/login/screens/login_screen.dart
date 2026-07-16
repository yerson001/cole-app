import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/auth/data/models/auth_response.dart';
import 'package:coleapp/features/auth/presentation/login/bloc/login_bloc.dart';
import 'package:coleapp/features/auth/presentation/login/bloc/login_event.dart';
import 'package:coleapp/features/auth/presentation/login/bloc/login_state.dart';
import 'package:coleapp/features/auth/presentation/login/screens/login_content.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              final response = state.response;
              if (response is ErrorResource) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(response.message)),
                );
              } else if (response is SuccessResource) {
                final authResponse = response.data as AuthResponse;
                context.read<LoginBloc>().add(
                      SaveSession(authResponse: authResponse),
                    );
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  'dashboard',
                  (route) => false,
                );
              }
            },
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                final response = state.response;
                if (response is LoadingResource) {
                  return Stack(
                    children: [
                      LoginContent(state),
                      const Center(child: CircularProgressIndicator()),
                    ],
                  );
                }
                return LoginContent(state);
              },
            ),
          ),
        ],
      ),
    );
  }
}

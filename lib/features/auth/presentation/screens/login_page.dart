import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/auth/data/models/auth_response.dart';
import 'package:coleapp/features/auth/presentation/bloc/login_bloc.dart';
import 'package:coleapp/features/auth/presentation/bloc/login_event.dart';
import 'package:coleapp/features/auth/presentation/bloc/login_state.dart';
import 'package:coleapp/features/auth/presentation/screens/login_content.dart';

final _log = Logger('LOGIN');

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    _log.info('build()');
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          _log.info('BlocListener: response type = ${state.response.runtimeType}');
          final response = state.response;
          if (response is SuccessResource) {
            final authResponse = response.data as AuthResponse;
            _log.info('Success: token=${authResponse.token} roles=${authResponse.user.roles}');
            context.read<LoginBloc>().add(SaveSession(authResponse, state.rememberMe));
            if (authResponse.user.roles.length > 1) {
              _log.info('Multiples roles, navegando a selector');
              Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
            } else {
              _log.info('Rol unico, navegando a home');
              Navigator.pushReplacementNamed(context, 'home');
            }
          } else if (response is ErrorResource) {
            _log.warning('Error: ${response.message}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(response.message)),
            );
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            if (state.response is LoadingResource) {
              _log.info('Mostrando spinner');
              return const Center(child: CircularProgressIndicator());
            }
            return const LoginContent();
          },
        ),
      ),
    );
  }
}

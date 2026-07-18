import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:coleapp/features/auth/presentation/bloc/login_bloc.dart';
import 'package:coleapp/features/auth/presentation/bloc/login_event.dart';
import 'package:coleapp/features/auth/presentation/bloc/login_state.dart';

final _log = Logger('LOGIN');

class LoginContent extends StatefulWidget {
  const LoginContent({super.key});

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent> {
  final _tenantCtrl = TextEditingController();
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _remember = false;

  @override
  void initState() {
    super.initState();
    _log.info('initState()');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoginBloc>().add(LoadSavedData());
    });
  }

  @override
  void dispose() {
    _tenantCtrl.dispose();
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (prev, current) =>
          prev.tenant != current.tenant ||
          prev.username != current.username ||
          prev.password != current.password ||
          prev.rememberMe != current.rememberMe,
      listener: (context, state) {
        _tenantCtrl.text = state.tenant.value;
        _userCtrl.text = state.username.value;
        _passCtrl.text = state.password.value;
        if (mounted) setState(() => _remember = state.rememberMe);
      },
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _tenantCtrl,
              decoration: const InputDecoration(labelText: 'Código del colegio'),
              onChanged: (v) {
                _log.info('tenant -> "$v"');
                context.read<LoginBloc>().add(TenantChanged(v));
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _userCtrl,
              decoration: const InputDecoration(labelText: 'Usuario'),
              onChanged: (v) {
                _log.info('username -> "$v"');
                context.read<LoginBloc>().add(UsernameChanged(v));
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passCtrl,
              obscureText: _obscurePass,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePass ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    _log.info('toggle password visibility');
                    setState(() => _obscurePass = !_obscurePass);
                  },
                ),
              ),
              onChanged: (v) {
                _log.info('password -> "$v"');
                context.read<LoginBloc>().add(PasswordChanged(v));
              },
            ),
            Row(
              children: [
                Checkbox(
                  value: _remember,
                  onChanged: (v) {
                    _log.info('rememberMe: ${v ?? false}');
                    setState(() => _remember = v ?? false);
                    context
                        .read<LoginBloc>()
                        .add(RememberMeChanged(v ?? false));
                  },
                ),
                const Text('Recordar contraseña'),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _log.info('Botón presionado -> LoginSubmit');
                context.read<LoginBloc>().add(LoginSubmit());
              },
              child: const Text('Iniciar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}

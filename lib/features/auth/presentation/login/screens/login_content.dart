import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/themes/app_colors.dart';
import 'package:coleapp/features/auth/presentation/login/bloc/login_bloc.dart';
import 'package:coleapp/features/auth/presentation/login/bloc/login_event.dart';
import 'package:coleapp/features/auth/presentation/login/bloc/login_state.dart';
import 'package:coleapp/shared/utils/bloc_form_item.dart';
import 'package:coleapp/shared/widgets/default_text_field.dart';
import 'package:coleapp/shared/widgets/default_button.dart';

class LoginContent extends StatefulWidget {
  final LoginState state;

  const LoginContent(this.state, {super.key});

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.state.formKey,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF003366), Color(0xFF001a33)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                _logoBanner(),
                const SizedBox(height: 40),

                // Tenant Key field
                DefaultTextField(
                  onChanged: (text) {
                    context.read<LoginBloc>().add(
                          TenantKeyChanged(
                              tenantKey: BlocFormItem(value: text)),
                        );
                  },
                  validator: (value) {
                    return widget.state.tenantKey.error;
                  },
                  label: 'Código del colegio',
                  icon: Icons.business,
                  keyboardType: TextInputType.text,
                ),

                // DNI field
                DefaultTextField(
                  onChanged: (text) {
                    context.read<LoginBloc>().add(
                          DniChanged(dni: BlocFormItem(value: text)),
                        );
                  },
                  validator: (value) {
                    return widget.state.dni.error;
                  },
                  label: 'Número de DNI',
                  icon: Icons.pin,
                  margin: const EdgeInsets.only(top: 10),
                  keyboardType: TextInputType.number,
                ),

                // Password field
                DefaultTextField(
                  onChanged: (text) {
                    context.read<LoginBloc>().add(
                          PasswordChanged(password: BlocFormItem(value: text)),
                        );
                  },
                  validator: (value) {
                    return widget.state.password.error;
                  },
                  label: 'Contraseña',
                  isPassword: _obscurePassword,
                  icon: Icons.lock_outline,
                  margin: const EdgeInsets.only(top: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 60),

                DefaultButton(
                  text: "Iniciar sesión",
                  color: AppColors.accent,
                  margin: const EdgeInsets.only(left: 0, right: 0),
                  onPressed: () {
                    final formKey = widget.state.formKey;
                    if (formKey?.currentState?.validate() ?? false) {
                      formKey!.currentState!.save();
                      context.read<LoginBloc>().add(FormSubmitted());
                    }
                  },
                  cBorder: 0,
                  textColor: Colors.white,
                ),

                const SizedBox(height: 20),
                Text(
                  '¿Problemas? Contacta al administrador',
                  style: TextStyle(color: Colors.grey[400], fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _logoBanner() {
    return Column(
      children: [
        const Icon(Icons.school, size: 80, color: AppColors.accent),
        const SizedBox(width: 8),
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'COLE',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accent,
                ),
              ),
              TextSpan(
                text: 'CHECK',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Inicia sesión para continuar',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[300],
          ),
        ),
      ],
    );
  }
}

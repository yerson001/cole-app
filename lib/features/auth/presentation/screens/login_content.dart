import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:coleapp/core/themes/app_colors.dart';
import 'package:coleapp/core/themes/theme_cubit.dart';
import 'package:coleapp/features/auth/data/datasource/local/auth_local_storage.dart';
import 'package:coleapp/features/auth/presentation/bloc/login_bloc.dart';
import 'package:coleapp/features/auth/presentation/bloc/login_event.dart';
import 'package:coleapp/features/auth/presentation/bloc/login_state.dart';
import 'package:coleapp/injection.dart';
import 'package:coleapp/shared/widgets/default_texfield.dart';
import 'package:coleapp/shared/widgets/defauld_onboard_button.dart';

final _log = Logger('LOGIN');

class LoginContent extends StatefulWidget {
  const LoginContent({super.key});

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent> {
  final _tenantKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  TutorialCoachMark? _tutorial;
  bool _obscurePass = true;
  bool _remember = false;
  String _tenant = '';
  bool _tenantLoaded = false;
  bool _autoCoachShown = true;
  String _usernameInit = '';
  String _passwordInit = '';
  int _formKeyCounter = 0;

  @override
  void initState() {
    super.initState();
    _log.info('initState()');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoginBloc>().add(LoadSavedData());
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (_tenant.isEmpty && _autoCoachShown) {
          _autoCoachShown = false;
          _showTutorial();
        }
      });
    });
  }

  @override
  void dispose() {
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
        if (!_tenantLoaded) {
          _tenant = state.tenant.value;
          _usernameInit = state.username.value;
          _passwordInit = state.password.value;
          _tenantLoaded = true;
          _formKeyCounter++;
        }
        if (mounted) setState(() => _remember = state.rememberMe);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTopBar(),
                const SizedBox(height: 40),
                _buildLogo(),
                const SizedBox(height: 20),
                const SizedBox(height: 20),
                const Text(
                  'Inicia sesión para continuar',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                const SizedBox(height: 16),
                _buildFormSection(),
                const SizedBox(height: 120),
                _buildFooter(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              final cubit = context.read<ThemeCubit>();
              return GestureDetector(
                onTap: () => cubit.cycle(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(cubit.icon, size: 20, color: Theme.of(context).colorScheme.primary),
                ),
              );
            },
          ),
          GestureDetector(
            onTap: _showTenantDialog,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  key: _tenantKey,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.business,
                    size: 20,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _tenant.isNotEmpty
                        ? AppColors.success
                        : AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    final disabled = _tenant.isEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Opacity(
        opacity: disabled ? 0.5 : 1.0,
        child: AbsorbPointer(
          absorbing: disabled,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DefaultTexfield(
                  key: ValueKey('user_$_formKeyCounter'),
                  text: 'Usuario',
                  icon: Icons.person_outline,
                  initialValue: _usernameInit,
                  margin: EdgeInsets.zero,
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    _log.info('username -> "$v"');
                    context.read<LoginBloc>().add(UsernameChanged(v));
                  },
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Ingrese su usuario';
                    if (v.trim().length < 8) return 'Mínimo 8 caracteres';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DefaultTexfield(
                  key: ValueKey('pass_$_formKeyCounter'),
                  text: 'Contraseña',
                  icon: Icons.lock_outline,
                  initialValue: _passwordInit,
                  isPassword: _obscurePass,
                  margin: EdgeInsets.zero,
                  onChanged: (v) {
                    _log.info('password -> "$v"');
                    context.read<LoginBloc>().add(PasswordChanged(v));
                  },
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Ingrese su contraseña' : null,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: IconButton(
                      icon: Icon(
                        _obscurePass ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _obscurePass = !_obscurePass),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: Checkbox(
                          value: _remember,
                          activeColor: AppColors.primary,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          onChanged: disabled
                              ? null
                              : (v) {
                                  setState(() => _remember = v ?? false);
                                  context.read<LoginBloc>().add(RememberMeChanged(v ?? false));
                                },
                        ),
                      ),
                      GestureDetector(
                        onTap: disabled
                            ? null
                            : () {
                                final newVal = !_remember;
                                setState(() => _remember = newVal);
                                context.read<LoginBloc>().add(RememberMeChanged(newVal));
                              },
                        child: const Text(
                          'Recordar contraseña',
                          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTenantDialog() async {
    _log.info('Abriendo diálogo de tenant');
    await showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: _TenantSheet(
          initialTenant: _tenant,
          onSave: (val) {
            setState(() => _tenant = val);
            context.read<LoginBloc>().add(TenantChanged(val));
            _saveTenant(val);
          },
          onClear: () {
            setState(() => _tenant = '');
            context.read<LoginBloc>().add(TenantChanged(''));
            _removeTenant();
          },
        ),
      ),
    );
    if (_tenant.isEmpty) {
      _showTutorial();
    }
  }

  Future<void> _saveTenant(String tenant) async {
    final storage = locator<AuthLocalStorage>();
    await storage.save('tenant', tenant);
    _log.info('Tenant guardado: $tenant');
  }

  Future<void> _removeTenant() async {
    final storage = locator<AuthLocalStorage>();
    await storage.remove('tenant');
    _log.info('Tenant eliminado');
  }

  void _showTutorial() {
    _log.info('Mostrando tutorial coach mark');
    _tutorial = TutorialCoachMark(
      targets: [
        TargetFocus(
          identify: 'tenant_button',
          keyTarget: _tenantKey,
          shape: ShapeLightFocus.RRect,
          radius: 12,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Encuentra tu colegio',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Toca aquí para configurar el código de tu institución y poder iniciar sesión',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
      textSkip: 'Saltar',
      showSkipInLastTarget: true,
      colorShadow: Colors.black87,
      paddingFocus: 8,
      opacityShadow: 0.75,
      alignSkip: Alignment.bottomLeft,
      onClickTarget: (_) {
        _tutorial?.finish();
        _showTenantDialog();
      },
      onSkip: () {
        _log.info('Tutorial saltado');
        return true;
      },
      onFinish: () => _log.info('Tutorial completado'),
    );
    _tutorial!.show(context: context);
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/cole.png', height: 44, fit: BoxFit.contain),
            const SizedBox(width: 6),
            Image.asset('assets/images/check.png', height: 44, fit: BoxFit.contain),
          ],
        ),
      ],
    );
  }

  Widget _buildButton() {
    return DefauldOnboardButton(
      text: 'Iniciar sesión',
      color: AppColors.primary,
      textColor: Colors.white,
      margin: EdgeInsets.zero,
      cBorder: 0,
      onPressed: () {
        if (_tenant.isEmpty) {
          _log.warning('Intento de login sin tenant');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Configura tu colegio primero'),
              backgroundColor: Colors.orange.shade800,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 4),
              action: SnackBarAction(
                label: 'Configurar',
                textColor: Colors.white,
                onPressed: _showTenantDialog,
              ),
            ),
          );
          _showTutorial();
          return;
        }
        if (!_formKey.currentState!.validate()) {
          _log.warning('Validación local falló');
          return;
        }
        _log.info('Botón presionado -> LoginSubmit');
        context.read<LoginBloc>().add(LoginSubmit());
      },
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        const Text(
          '© 2026 Colecheck App',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 4),
        Text(
          'Colecheck SAC',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _log.info('Políticas de privacidad'),
              child: const Text(
                'Políticas de privacidad',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const Text(
              '  ·  ',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            GestureDetector(
              onTap: () => _log.info('Términos de uso'),
              child: const Text(
                'Términos de uso',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TenantSheet extends StatefulWidget {
  final String initialTenant;
  final void Function(String) onSave;
  final VoidCallback onClear;

  const _TenantSheet({
    required this.initialTenant,
    required this.onSave,
    required this.onClear,
  });

  @override
  State<_TenantSheet> createState() => _TenantSheetState();
}

class _TenantSheetState extends State<_TenantSheet> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initialTenant);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 24),
              const Text(
                'Encuentra tu colegio',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textSecondary, size: 24),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Padding(
            padding: EdgeInsets.only(left: 24),
            child: Text(
              'Ingresa el código de la Insitución Educativa',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 20),
          DefaultTexfield(
            text: 'Código del colegio',
            icon: Icons.business_outlined,
            controller: _ctrl,
            onChanged: (_) {},
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                final val = _ctrl.text.trim();
                widget.onSave(val);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Guardar',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          if (widget.initialTenant.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () {
                  _ctrl.clear();
                  widget.onClear();
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Limpiar',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

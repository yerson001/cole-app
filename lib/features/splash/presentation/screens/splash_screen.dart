import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:coleapp/core/themes/app_colors.dart';
import 'package:coleapp/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:coleapp/features/splash/presentation/bloc/splash_event.dart';
import 'package:coleapp/features/splash/presentation/bloc/splash_state.dart';
import 'package:coleapp/notifications/notification_service.dart';

final _log = Logger('SPLASH');

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _checkScale;
  late final Animation<double> _coleWidth;
  late final Animation<double> _coleFade;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _log.info('initState()');

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _checkScale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
      ),
    );

    _coleWidth = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
      ),
    );

    _coleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.7, curve: Curves.easeIn),
      ),
    );

    _progress = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();
    _log.info('Animación iniciada');

    final delay = PendingNotificationRoute().hasPending
        ? Duration.zero
        : const Duration(seconds: 2);
    Future.delayed(delay, () {
      if (mounted) {
        context.read<SplashBloc>().add(CheckSplashSession());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashSessionFound) {
          final roles = state.authResponse.user.roles;
          if (PendingNotificationRoute().hasPending) {
            _log.info('Sesión activa con notificación pendiente, navegando a parent/home');
            Navigator.pushReplacementNamed(context, 'parent/home');
            return;
          }
          if (roles.length > 1) {
            _log.info('Sesión activa con múltiples roles, navegando a selector');
            Navigator.pushReplacementNamed(context, 'roles');
          } else {
            _log.info('Sesión activa, navegando a ${roles.first.route}');
            Navigator.pushReplacementNamed(context, roles.first.route);
          }
        } else if (state is SplashSessionNotFound) {
          _log.info('Sin sesión, navegando a login');
          Navigator.pushReplacementNamed(context, 'login');
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [bgColor, c.surface],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizeTransition(
                          sizeFactor: _coleWidth,
                          axis: Axis.horizontal,
                          alignment: Alignment.centerLeft,
                          child: Opacity(
                            opacity: _coleFade.value,
                            child: Image.asset(
                              'assets/images/cole.png',
                              height: 60,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Transform.scale(
                          scale: _checkScale.value,
                          child: Image.asset(
                            'assets/images/check.png',
                            height: 60, 
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const Spacer(flex: 1),
                _DotSpinner(color: c.primary),
                const SizedBox(height: 24),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100),
                    child: LinearProgressIndicator(
                      value: _progress.value,
                      backgroundColor: c.primary.withValues(alpha: 0.1),
                      color: c.primary,
                      minHeight: 4,
                    ),
                  ),
                ),
                const Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DotSpinner extends StatefulWidget {
  final Color color;
  const _DotSpinner({required this.color});

  @override
  State<_DotSpinner> createState() => _DotSpinnerState();
}

class _DotSpinnerState extends State<_DotSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _anim = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (i) {
          final delay = i * 0.15;
          final value = (_anim.value - delay).clamp(0.0, 1.0);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Opacity(
              opacity: value,
              child: Icon(Icons.circle, size: 10, color: widget.color),
            ),
          );
        }),
      ),
      child: const SizedBox(),
    );
  }
}

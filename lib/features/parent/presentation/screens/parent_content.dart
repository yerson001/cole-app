import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/themes/app_colors.dart';
import 'package:coleapp/core/themes/theme_cubit.dart';
import 'package:coleapp/features/auth/presentation/bloc/login_bloc.dart';
import 'package:coleapp/features/auth/presentation/bloc/login_event.dart';
import 'package:coleapp/features/auth/presentation/screens/login_page.dart';
import 'package:coleapp/features/parent/presentation/bloc/parent_bloc.dart';
import 'package:coleapp/features/parent/presentation/bloc/parent_event.dart';
import 'package:coleapp/features/parent/presentation/bloc/parent_state.dart';
import 'package:coleapp/core/themes/theme_page.dart';
import 'package:coleapp/features/profile/presentation/screens/info/profile_info_page.dart';

class ParentContent extends StatefulWidget {
  const ParentContent({super.key});

  @override
  State<ParentContent> createState() => _ParentContentState();
}

class _ParentContentState extends State<ParentContent> {
  final List<Widget> pageList = const [
    _HomePage(),
    ProfileInfoPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: _buildDrawer(context),
      body: BlocBuilder<ParentBloc, ParentState>(
        builder: (context, state) {
          return pageList[state.pageIndex];
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: Builder(
        builder: (ctx) {
          final state = context.watch<ParentBloc>().state;
          if (state.pageIndex > 0) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                context.read<ParentBloc>().add(ChangePage(pageIndex: 0));
              },
            );
          }
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          );
        },
      ),
      centerTitle: true,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final ac = context.appColors;
    final parentBloc = context.read<ParentBloc>();
    final loginBloc = context.read<LoginBloc>();
    final user = parentBloc.state.user;
    final roleName = user != null && user.roles.isNotEmpty
        ? user.roles.first.displayName
        : 'Padre';
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 48, 20, 24),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ac.primary,
                  ac.primary.withValues(alpha: 0.85),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: ac.primary, size: 30),
                ),
                const SizedBox(height: 12),
                Text(
                  'Menú del $roleName',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: ac.surface,
              child: BlocBuilder<ParentBloc, ParentState>(
              builder: (context, state) {
                final cs = Theme.of(context).colorScheme;
                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4, top: 12, bottom: 4),
                      child: Text(
                        'GENERAL',
                        style: TextStyle(
                          color: cs.onSurface.withValues(alpha: 0.6),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.home_outlined, color: ac.primary),
                      title: const Text('Inicio'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                      selected: state.pageIndex == 0,
                      onTap: () {
                        context.read<ParentBloc>().add(ChangePage(pageIndex: 0));
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.person_outline, color: ac.primary),
                      title: const Text('Perfil'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                      selected: state.pageIndex == 1,
                      onTap: () {
                        context.read<ParentBloc>().add(ChangePage(pageIndex: 1));
                        Navigator.pop(context);
                      },
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.only(left: 4, top: 16, bottom: 4),
                      child: Text(
                        'PREFERENCIAS',
                        style: TextStyle(
                          color: cs.onSurface.withValues(alpha: 0.6),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(context.watch<ThemeCubit>().icon, color: ac.primary),
                      title: const Text('Tema'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(builder: (_) => const ThemePage()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.security, color: ac.primary),
                      title: const Text('Roles'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context, rootNavigator: true).pushNamed('roles');
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text(
                        'Cerrar sesión',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        parentBloc.add(Logout());
                        loginBloc.add(ResetLogin());
                        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                  );
                },
              ),
            ),
          ),
          ],
        ),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final user = context.watch<ParentBloc>().state.user;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.school_outlined,
              size: 64, color: c.onSurface.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(
            'Bienvenido',
            style: TextStyle(
              fontSize: 20,
              color: c.onSurface.withValues(alpha: 0.5),
            ),
          ),
          if (user != null) ...[
            Text(
              user.username,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              user.person?.name ?? '',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              user.person?.lastName ?? '',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/themes/app_colors.dart';
import 'package:coleapp/features/director/presentation/bloc/director_bloc.dart';
import 'package:coleapp/features/director/presentation/bloc/director_event.dart';
import 'package:coleapp/features/director/presentation/bloc/director_state.dart';
import 'package:coleapp/features/roles/presentation/screens/roles_page.dart';

class DirectorScreen extends StatefulWidget {
  const DirectorScreen({super.key});

  @override
  State<DirectorScreen> createState() => _DirectorScreenState();
}

class _DirectorScreenState extends State<DirectorScreen> {
  final List<Widget> pageList = <Widget>[
    const _PlaceholderPage(icon: Icons.dashboard, label: 'Dashboard'),
    const _PlaceholderPage(icon: Icons.people, label: 'Usuarios'),
    const _PlaceholderPage(icon: Icons.school, label: 'Cursos'),
    const _PlaceholderPage(icon: Icons.assessment, label: 'Reportes'),
    const RolesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Director'),
      ),
      body: BlocBuilder<DirectorBloc, DirectorState>(
        builder: (context, state) {
          return pageList[state.pageIndex];
        },
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          context.read<DirectorBloc>().add(Logout());
          Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.logout, color: Colors.white),
      ),
      drawer: BlocBuilder<DirectorBloc, DirectorState>(
        builder: (context, state) {
          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(color: AppColors.primary),
                  child: const Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Menú del Director',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // GENERAL
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'GENERAL',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.dashboard, color: Colors.black),
                        title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        selected: state.pageIndex == 0,
                        onTap: () {
                          context.read<DirectorBloc>().add(ChangeDrawerPage(pageIndex: 0));
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.people, color: Colors.black),
                        title: const Text('Usuarios', style: TextStyle(fontWeight: FontWeight.bold)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        selected: state.pageIndex == 1,
                        onTap: () {
                          context.read<DirectorBloc>().add(ChangeDrawerPage(pageIndex: 1));
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.school, color: Colors.black),
                        title: const Text('Cursos', style: TextStyle(fontWeight: FontWeight.bold)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        selected: state.pageIndex == 2,
                        onTap: () {
                          context.read<DirectorBloc>().add(ChangeDrawerPage(pageIndex: 2));
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.assessment, color: Colors.black),
                        title: const Text('Reportes', style: TextStyle(fontWeight: FontWeight.bold)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        selected: state.pageIndex == 3,
                        onTap: () {
                          context.read<DirectorBloc>().add(ChangeDrawerPage(pageIndex: 3));
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                // PREFERENCIAS
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Text(
                    'PREFERENCIAS',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.security, color: Colors.black),
                        title: const Text('Roles de usuario', style: TextStyle(fontWeight: FontWeight.bold)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        selected: state.pageIndex == 4,
                        onTap: () {
                          context.read<DirectorBloc>().add(ChangeDrawerPage(pageIndex: 4));
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text('Cerrar sesión', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          context.read<DirectorBloc>().add(Logout());
                          Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  final IconData icon;
  final String label;
  const _PlaceholderPage({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: AppColors.primary.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(label, style: const TextStyle(fontSize: 24, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

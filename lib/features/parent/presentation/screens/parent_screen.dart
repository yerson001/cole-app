import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/themes/app_colors.dart';
import 'package:coleapp/features/parent/presentation/bloc/parent_bloc.dart';
import 'package:coleapp/features/parent/presentation/bloc/parent_event.dart';
import 'package:coleapp/features/parent/presentation/bloc/parent_state.dart';
import 'package:coleapp/features/roles/presentation/screens/roles_page.dart';

class ParentScreen extends StatefulWidget {
  const ParentScreen({super.key});

  @override
  State<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  final List<Widget> pageList = <Widget>[
    const _PlaceholderPage(icon: Icons.family_restroom, label: 'Mis Hijos'),
    const _PlaceholderPage(icon: Icons.grading, label: 'Notas'),
    const _PlaceholderPage(icon: Icons.fact_check, label: 'Asistencia'),
    const _PlaceholderPage(icon: Icons.payment, label: 'Pagos'),
    const RolesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Padre'),
      ),
      body: BlocBuilder<ParentBloc, ParentState>(
        builder: (context, state) {
          return pageList[state.pageIndex];
        },
      ),
      drawer: BlocBuilder<ParentBloc, ParentState>(
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
                      'Menú del Padre',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('GENERAL', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.family_restroom, color: Colors.black),
                        title: const Text('Mis Hijos', style: TextStyle(fontWeight: FontWeight.bold)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        selected: state.pageIndex == 0,
                        onTap: () {
                          context.read<ParentBloc>().add(ChangeDrawerPage(pageIndex: 0));
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.grading, color: Colors.black),
                        title: const Text('Notas', style: TextStyle(fontWeight: FontWeight.bold)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        selected: state.pageIndex == 1,
                        onTap: () {
                          context.read<ParentBloc>().add(ChangeDrawerPage(pageIndex: 1));
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.fact_check, color: Colors.black),
                        title: const Text('Asistencia', style: TextStyle(fontWeight: FontWeight.bold)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        selected: state.pageIndex == 2,
                        onTap: () {
                          context.read<ParentBloc>().add(ChangeDrawerPage(pageIndex: 2));
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.payment, color: Colors.black),
                        title: const Text('Pagos', style: TextStyle(fontWeight: FontWeight.bold)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        selected: state.pageIndex == 3,
                        onTap: () {
                          context.read<ParentBloc>().add(ChangeDrawerPage(pageIndex: 3));
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Text('PREFERENCIAS', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
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
                          context.read<ParentBloc>().add(ChangeDrawerPage(pageIndex: 4));
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text('Cerrar sesión', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          context.read<ParentBloc>().add(Logout());
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/themes/app_colors.dart';
import 'package:coleapp/features/assistant/presentation/bloc/assistant_bloc.dart';
import 'package:coleapp/features/assistant/presentation/bloc/assistant_event.dart';
import 'package:coleapp/features/assistant/presentation/bloc/assistant_state.dart';
import 'package:coleapp/features/roles/presentation/screens/roles_page.dart';

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final List<Widget> pageList = <Widget>[
    const _PlaceholderPage(icon: Icons.fact_check, label: 'Asistencia'),
    const _PlaceholderPage(icon: Icons.support, label: 'Apoyo'),
    const RolesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Auxiliar'),
      ),
      body: BlocBuilder<AssistantBloc, AssistantState>(
        builder: (context, state) {
          return pageList[state.pageIndex];
        },
      ),
      drawer: BlocBuilder<AssistantBloc, AssistantState>(
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
                      'Menú del Auxiliar',
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
                        leading: const Icon(Icons.fact_check, color: Colors.black),
                        title: const Text('Asistencia', style: TextStyle(fontWeight: FontWeight.bold)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        selected: state.pageIndex == 0,
                        onTap: () {
                          context.read<AssistantBloc>().add(ChangeDrawerPage(pageIndex: 0));
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.support, color: Colors.black),
                        title: const Text('Apoyo', style: TextStyle(fontWeight: FontWeight.bold)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        selected: state.pageIndex == 1,
                        onTap: () {
                          context.read<AssistantBloc>().add(ChangeDrawerPage(pageIndex: 1));
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
                        selected: state.pageIndex == 2,
                        onTap: () {
                          context.read<AssistantBloc>().add(ChangeDrawerPage(pageIndex: 2));
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text('Cerrar sesión', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          context.read<AssistantBloc>().add(Logout());
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
